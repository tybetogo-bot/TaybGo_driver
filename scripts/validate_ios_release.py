#!/usr/bin/env python3
"""Inspect a Driver app bundle; signed exports require production entitlements."""
import argparse
import hashlib
import json
import plistlib
import subprocess
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('app', type=Path)
parser.add_argument('--unsigned', action='store_true')
parser.add_argument('--output', type=Path, required=True)
args = parser.parse_args()
app = args.app.resolve()
info = plistlib.loads((app / 'Info.plist').read_bytes())
firebase = plistlib.loads((app / 'GoogleService-Info.plist').read_bytes())
checks = {}
checks['bundle_id'] = info.get('CFBundleIdentifier') == 'com.taybgo.driver'
checks['display_name'] = info.get('CFBundleDisplayName') == 'TaybGo Driver'
checks['firebase_identity'] = (
    firebase.get('BUNDLE_ID') == 'com.taybgo.driver'
    and firebase.get('PROJECT_ID') == 'drivertaybgo'
    and firebase.get('GOOGLE_APP_ID') == '1:527527512549:ios:e08595c6813c6ac8d1c70c'
)
scene = info.get('UIApplicationSceneManifest', {}).get('UISceneConfigurations', {}).get('UIWindowSceneSessionRoleApplication', [])
checks['scene'] = any(s.get('UISceneDelegateClassName', '').endswith('.SceneDelegate') for s in scene)
checks['sounds'] = all((app / f'signal_{n}.wav').is_file() for n in range(1, 4))
checks['flutter_assets'] = (app / 'Frameworks/App.framework/flutter_assets').is_dir()
checks['location_permissions'] = all(info.get(k) for k in ['NSLocationWhenInUseUsageDescription', 'NSLocationAlwaysAndWhenInUseUsageDescription'])
checks['camera_photo_permissions'] = all(info.get(k) for k in ['NSCameraUsageDescription', 'NSPhotoLibraryUsageDescription'])
manifests = list(app.rglob('PrivacyInfo.xcprivacy'))
privacy = []
for path in manifests:
    try:
        plistlib.loads(path.read_bytes())
        privacy.append({'path': str(path.relative_to(app)), 'valid_plist': True})
    except Exception as error:
        privacy.append({'path': str(path.relative_to(app)), 'valid_plist': False, 'error': str(error)})
checks['privacy_plist_syntax'] = bool(privacy) and all(p['valid_plist'] for p in privacy)
entitlements = None
if not args.unsigned:
    result = subprocess.run(['codesign', '--verify', '--deep', '--strict', str(app)], capture_output=True, text=True)
    checks['strict_signature'] = result.returncode == 0
    result = subprocess.run(['codesign', '-d', '--entitlements', ':-', str(app)], capture_output=True)
    entitlements = plistlib.loads(result.stdout)
    checks['production_push'] = entitlements.get('aps-environment') == 'production'
    checks['debugging_disabled'] = entitlements.get('get-task-allow') is False
    result = subprocess.run(['security', 'cms', '-D', '-i', str(app / 'embedded.mobileprovision')], capture_output=True)
    profile = plistlib.loads(result.stdout)
    checks['app_store_profile'] = not profile.get('ProvisionedDevices') and not profile.get('ProvisionsAllDevices', False)
    checks['profile_identity'] = profile.get('Entitlements', {}).get('application-identifier', '').endswith('.com.taybgo.driver')
binary = app / info['CFBundleExecutable']
arch = subprocess.run(['lipo', '-archs', str(binary)], capture_output=True, text=True)
checks['arm64'] = arch.returncode == 0 and 'arm64' in arch.stdout.split()
report = {
    'app': str(app), 'signed_export_inspected': not args.unsigned,
    'version': info.get('CFBundleShortVersionString'), 'build': info.get('CFBundleVersion'),
    'minimum_os': info.get('MinimumOSVersion'), 'architectures': arch.stdout.strip(),
    'checks': checks, 'privacy_manifests': privacy, 'entitlements': entitlements,
    'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(),
    'limits': ['No physical-device, TestFlight, backend or store-console verification.',
               'Privacy plist syntax does not validate disclosure accuracy.',
               'Production API configuration also needs workflow testing.'],
}
args.output.parent.mkdir(parents=True, exist_ok=True)
args.output.write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(checks, indent=2))
raise SystemExit(0 if all(checks.values()) else 1)
