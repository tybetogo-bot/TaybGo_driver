#!/bin/sh
set -eu
if [ "$#" -ne 3 ]; then
  echo 'Usage: GOOGLE_MAPS_API_KEY=... sh scripts/build_ios_store.sh VERSION UNUSED_BUILD EXPORT_OPTIONS_PLIST' >&2
  exit 2
fi
if ! printf '%s' "${GOOGLE_MAPS_API_KEY:-}" | LC_ALL=C grep -Eq '^AIza[0-9A-Za-z_-]{20,}$'; then
  echo 'A valid production GOOGLE_MAPS_API_KEY is required for driver address selection.' >&2
  exit 1
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
  --dart-define=GOOGLE_MAPS_API_KEY="$GOOGLE_MAPS_API_KEY" \
  --export-options-plist="$3"
