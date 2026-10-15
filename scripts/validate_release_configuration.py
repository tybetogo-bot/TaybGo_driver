#!/usr/bin/env python3
"""Verify client configuration inside release binaries without printing keys."""
import argparse
import hashlib
import json
import plistlib
import re
import subprocess
import tempfile
import wave
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--ipa', type=Path)
parser.add_argument('--aab', type=Path)
parser.add_argument('--defines-file', type=Path, required=True)
parser.add_argument('--version', required=True)
parser.add_argument('--build', required=True)
parser.add_argument('--output', type=Path, required=True)
parser.add_argument('--aapt2', type=Path)
args = parser.parse_args()
if not args.ipa and not args.aab:
    parser.error('Provide --ipa and/or --aab.')

places = json.loads(args.defines_file.read_text()).get('GOOGLE_MAPS_API_KEY', '')
if not isinstance(places, str) or not re.fullmatch(r'AIza[0-9A-Za-z_-]{20,}', places):
    parser.error('The local Places definition is missing or invalid.')
cloudinary = (ROOT / 'lib/core/constants/cloudinary_constants.dart').read_text()
cloud_name = re.search(r"cloudName = '([^']+)'", cloudinary).group(1)
upload_preset = re.search(r"uploadPreset = '([^']+)'", cloudinary).group(1)
source_firebase = (ROOT / 'lib/firebase_options.dart').read_text()
checks = {}
artifacts = {}


def inspect_aot(data):
    return {
        'places_key_matches_local_definition': places.encode() in data,
        'production_api_url_present': b'https://taybgo.com/api' in data,
        'cloudinary_cloud_present': cloud_name.encode() in data,
        'cloudinary_upload_preset_present': upload_preset.encode() in data,
    }


def dart_firebase_matches(platform, api_key, app_id):
    section = re.search(rf'{platform}Prod = FirebaseOptions\((.*?)\n  \);', source_firebase, re.S).group(1)
    return f"apiKey: '{api_key}'" in section and f"appId: '{app_id}'" in section


if args.ipa:
    with zipfile.ZipFile(args.ipa) as archive:
        prefix = next(name[:-len('Info.plist')] for name in archive.namelist()
                      if re.fullmatch(r'Payload/[^/]+\.app/Info.plist', name))
        info = plistlib.loads(archive.read(prefix + 'Info.plist'))
        firebase = plistlib.loads(archive.read(prefix + 'GoogleService-Info.plist'))
        data = archive.read(prefix + 'Frameworks/App.framework/App')
        ios = inspect_aot(data)
        ios.update({
            'bundle_id': info.get('CFBundleIdentifier') == 'com.taybgo.driver',
            'version': info.get('CFBundleShortVersionString') == args.version,
            'build': info.get('CFBundleVersion') == args.build,
            'firebase_project': firebase.get('PROJECT_ID') == 'drivertaybgo',
            'firebase_bundle': firebase.get('BUNDLE_ID') == 'com.taybgo.driver',
            'firebase_api_key_in_aot': firebase.get('API_KEY', '').encode() in data,
            'firebase_app_id_in_aot': firebase.get('GOOGLE_APP_ID', '').encode() in data,
            'firebase_dart_native_match': dart_firebase_matches('ios', firebase['API_KEY'], firebase['GOOGLE_APP_ID']),
        })
        with tempfile.TemporaryDirectory() as work:
            for number in range(1, 6):
                name = f'signal_{number}.wav'
                sound = archive.read(prefix + name)
                target = Path(work) / name
                target.write_bytes(sound)
                with wave.open(str(target)) as audio:
                    ios[f'{name}_under_30_seconds'] = 0 < audio.getnframes() / audio.getframerate() < 30
                ios[f'{name}_matches_source'] = sound == (ROOT / 'ios/Runner' / name).read_bytes()
        checks['ios'] = ios

if args.aab:
    with zipfile.ZipFile(args.aab) as archive:
        android = {}
        libraries = [name for name in archive.namelist() if re.fullmatch(r'base/lib/[^/]+/libapp\.so', name)]
        android['arm64_aot_present'] = 'base/lib/arm64-v8a/libapp.so' in libraries
        for name in libraries:
            architecture = name.split('/')[2]
            android[architecture] = inspect_aot(archive.read(name))
        config = json.loads((ROOT / 'android/app/google-services.json').read_text())
        client = next(c for c in config['client'] if c['client_info']['android_client_info']['package_name'] == 'com.taybgo.driver')
        api_key = client['api_key'][0]['current_key']
        app_id = client['client_info']['mobilesdk_app_id']
        resources = archive.read('base/resources.pb')
        android.update({
            'firebase_project': config['project_info']['project_id'] == 'drivertaybgo',
            'firebase_api_key_in_resources': api_key.encode() in resources,
            'firebase_app_id_in_resources': app_id.encode() in resources,
            'firebase_project_in_resources': b'drivertaybgo' in resources,
            'firebase_dart_native_match': dart_firebase_matches('android', api_key, app_id),
            'jar_signature_present': any(n.startswith('META-INF/') and n.endswith(('.RSA', '.EC')) for n in archive.namelist()),
        })
        for number in range(1, 6):
            sound = f'base/res/raw/signal_{number}.wav'
            android[f'signal_{number}_matches_source'] = sound in archive.namelist() and archive.read(sound) == (ROOT / f'android/app/src/main/res/raw/signal_{number}.wav').read_bytes()
        aapt2 = args.aapt2
        if aapt2 is None:
            aapt2 = sorted(Path('/opt/homebrew/share/android-commandlinetools/build-tools').glob('*/aapt2'))[-1]
        with tempfile.TemporaryDirectory() as work:
            proto = Path(work) / 'base-proto.apk'
            binary = Path(work) / 'base-binary.apk'
            with zipfile.ZipFile(proto, 'w', zipfile.ZIP_DEFLATED) as output:
                for name in archive.namelist():
                    if name == 'base/manifest/AndroidManifest.xml':
                        output.writestr('AndroidManifest.xml', archive.read(name))
                    elif name == 'base/resources.pb' or name.startswith('base/res/'):
                        output.writestr(name[len('base/'):], archive.read(name))
            converted = subprocess.run([str(aapt2), 'convert', '--output-format', 'binary', '-o', str(binary), str(proto)], capture_output=True)
            android['manifest_converted'] = converted.returncode == 0
            if converted.returncode == 0:
                result = subprocess.run([str(aapt2), 'dump', 'badging', str(binary)], capture_output=True, text=True)
                first = result.stdout.splitlines()[0] if result.stdout else ''
                android['package_id'] = "name='com.taybgo.driver'" in first
                android['version'] = f"versionName='{args.version}'" in first
                android['build'] = f"versionCode='{args.build}'" in first
        java = Path('/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home/bin')
        verified = subprocess.run([str(java / 'jarsigner'), '-verify', str(args.aab)], capture_output=True, text=True)
        android['jar_signature_verified'] = verified.returncode == 0 and 'jar verified.' in verified.stdout
        properties = dict(line.split('=', 1) for line in (ROOT / 'android/key.properties').read_text().splitlines() if '=' in line and not line.startswith('#'))
        keystore = Path(properties['storeFile'])
        if not keystore.is_absolute():
            keystore = ROOT / 'android/app' / keystore
        with tempfile.TemporaryDirectory() as work:
            password_file = Path(work) / 'store-password'
            password_file.touch(mode=0o600)
            password_file.write_text(properties['storePassword'])
            expected = subprocess.run([str(java / 'keytool'), '-exportcert', '-keystore', str(keystore), '-alias', properties['keyAlias'], '-storepass:file', str(password_file)], capture_output=True)
            certificate = subprocess.run([str(java / 'keytool'), '-printcert', '-rfc', '-jarfile', str(args.aab)], capture_output=True, text=True)
            import base64
            match = re.search(r'-----BEGIN CERTIFICATE-----\s*(.*?)\s*-----END CERTIFICATE-----', certificate.stdout, re.S)
            actual = base64.b64decode(match.group(1)) if match else b''
            android['upload_certificate_matches_local_keystore'] = expected.returncode == 0 and bool(actual) and actual == expected.stdout
            if actual:
                android['upload_certificate_sha256'] = hashlib.sha256(actual).hexdigest()
        checks['android'] = android

for platform, path in [('ios', args.ipa), ('android', args.aab)]:
    if path:
        artifacts[platform] = {'path': str(path.resolve()), 'bytes': path.stat().st_size,
                               'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}


def all_checks(value):
    if isinstance(value, dict):
        return all(all_checks(v) for v in value.values())
    return value is not False

passed = all_checks(checks)
report = {'version': args.version, 'build': args.build, 'passed': passed,
          'checks': checks, 'artifacts': artifacts,
          'limits': ['Binary configuration/signature inspection does not prove provider restrictions, device behavior, or store acceptance. No live push or payment requests.']}
args.output.parent.mkdir(parents=True, exist_ok=True)
args.output.write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({'passed': passed, 'checks': checks}, indent=2))
raise SystemExit(0 if passed else 1)
