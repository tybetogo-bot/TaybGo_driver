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

- The signed AAB reports `com.taybgo.driver`, version `1.0.18`, build `22`.
- Android Dart AOT binaries contain the exact local Places key, production API
  URL, and Cloudinary cloud/preset settings. Firebase native/Dart configuration
  matches, all five sounds match source, JAR signing verifies against the local
  upload keystore, and all 64-bit native libraries support 16 KB alignment.

- The exported IPA passes strict/deep signature verification, Apple Distribution
  certificate and App Store provisioning checks, expected signing team, production
  APNs entitlement, disabled debugging, privacy plist syntax, and matching Runner
  and App framework crash symbols. Bundle ID, version/build, Places key, production
  API URL, Firebase, Cloudinary, and all five bundled sounds pass validation.
- Both final artifacts have SHA-256 checksums and an ignored local release manifest.

Store packages are exported locally; store uploads are not part of this release
preparation. Live server-side validation does not prove physical-device behavior
or store acceptance.
