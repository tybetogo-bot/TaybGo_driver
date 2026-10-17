# Driver 1.0.18 (22)

Prepared October 17, 2026. PR targets `dev`.

## Changes

Display euros consistently across home, order items and totals, delivery fees,
tips, earnings summaries and entries, and profile earnings (including compact
thousands). Numeric amounts and precision remain unchanged.

## Production build configuration

Both store packages use `--release --flavor prod --target lib/main_prod.dart`,
version `1.0.18`, build `22`, and the existing ignored production definitions
file `releases/config/ios-prod.json`. No key values or signing credentials are
included in source control.

Local artifacts and validation reports are saved under
`releases/2026-10-17/driver-1.0.18-build22/`.

## Verification

- All 74 Flutter tests pass; static analysis reports no issues.
- No dollar currency formatting remains in app sources or assets.
- The configured Places key passes live Places API autocomplete and place details
  requests (HTTP 200), including address and coordinates.

Store packages are exported locally; store uploads are not part of this release
preparation. Live server-side validation does not prove physical-device behavior
or store acceptance.
