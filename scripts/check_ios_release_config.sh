#!/bin/sh
set -eu
case "${CONFIGURATION:-}" in
  Release*) ;;
  *) exit 0 ;;
esac
# Unsigned compilation is allowed for source validation before Apple signing.
if [ "${CODE_SIGNING_ALLOWED:-YES}" = NO ]; then
  exit 0
fi
valid_key=false
old_ifs=$IFS
IFS=,
for encoded in ${DART_DEFINES:-}; do
  decoded=$(printf '%s' "$encoded" | /usr/bin/base64 -D 2>/dev/null) || continue
  case "$decoded" in
    GOOGLE_MAPS_API_KEY=*)
      if printf '%s' "${decoded#GOOGLE_MAPS_API_KEY=}" | LC_ALL=C /usr/bin/grep -Eq '^AIza[0-9A-Za-z_-]{20,}$'; then
        valid_key=true
      fi
      ;;
  esac
done
IFS=$old_ifs
if [ "$valid_key" != true ]; then
  echo 'error: Signed Driver releases require GOOGLE_MAPS_API_KEY for the signup address step. Pass --dart-define=GOOGLE_MAPS_API_KEY=... with the production Places key.' >&2
  exit 1
fi
