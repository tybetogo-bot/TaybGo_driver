#!/bin/sh
set -eu
if [ "$#" -ne 3 ]; then
  echo 'Usage: sh scripts/build_ios_store.sh VERSION UNUSED_BUILD EXPORT_OPTIONS_PLIST (local defines file or GOOGLE_MAPS_API_KEY required)' >&2
  exit 2
fi
# Keep local API configuration out of source control and shell command history.
config_file=${IOS_PROD_DEFINES_FILE:-releases/config/ios-prod.json}
if [ -n "${GOOGLE_MAPS_API_KEY:-}" ]; then
  if ! printf '%s' "$GOOGLE_MAPS_API_KEY" | LC_ALL=C grep -Eq '^AIza[0-9A-Za-z_-]{20,}$'; then
    echo 'A valid production GOOGLE_MAPS_API_KEY is required.' >&2
    exit 1
  fi
  set -- "$1" "$2" "$3" "--dart-define=GOOGLE_MAPS_API_KEY=$GOOGLE_MAPS_API_KEY"
else
  python3 - "$config_file" <<'CHECK_CONFIG'
import json, re, sys
try:
    with open(sys.argv[1]) as source:
        key = json.load(source).get('GOOGLE_MAPS_API_KEY', '')
    assert isinstance(key, str) and re.fullmatch(r'AIza[0-9A-Za-z_-]{20,}', key)
except (OSError, ValueError, AssertionError, AttributeError):
    sys.exit('Provide a local production defines file with GOOGLE_MAPS_API_KEY.')
CHECK_CONFIG
  set -- "$1" "$2" "$3" "--dart-define-from-file=$config_file"
fi
if [ ! -f "$3" ]; then
  echo 'Provide Apple-verified App Store export options before building the signed IPA.' >&2
  exit 1
fi
flutter pub get --enforce-lockfile
flutter test --no-pub
flutter analyze --no-pub
flutter build ipa --release --no-pub --flavor prod --target lib/main_prod.dart \
  --build-name="$1" --build-number="$2" \
  "$4" \
  --export-options-plist="$3"
