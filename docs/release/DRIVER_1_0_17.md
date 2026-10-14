# Driver 1.0.17 (21)

Prepared October 14, 2026; signed artifact verification completed October 15, 2026.
Targets `dev` from compiled source commit `3ec3be6`.

## Changes

The home notification icon now shows an unread pill with a real inbox count,
coral indicator, and brief arrival animation. Reading a notification persists to
the backend; opening the inbox leaves unread items intact. The count refreshes on
entry, resume, manual refresh, foreground push, and every 30 seconds on home.
Dark mode, RTL, reduced motion, and all 11 app languages are supported.

Manual and forced logout share awaitable local cleanup. Requests, token rotation,
inbox/account loads, and location callbacks are fenced by login generation. New
login/token creation waits for previous FCM deletion. Transient refresh failures
preserve saved credentials. Existing sound/channel behavior is retained.

See `CHANGELOG.md` and `SESSION_PUSH_CLEANUP.md` for the full scope.

## Artifacts

The following local files are in the ignored directory
`releases/2026-10-14/driver-1.0.17-build21/`:

- `TaybGo-Driver-1.0.17+21-AppStore.ipa` — Apple Distribution signed, App Store profile.
- `TaybGo-Driver-1.0.17+21-prod.aab` — signed with the configured Android upload certificate.
- `SHA256SUMS`, `release-manifest.json`, and individual validation reports.

Both use `--flavor prod --target lib/main_prod.dart`, version `1.0.17`, build `21`,
and the existing ignored `releases/config/ios-prod.json` definitions file.
Configuration values are not copied into release documentation or Git history.

## Verification

- All 74 Flutter tests passed; static analysis reported no issues.
- Both artifacts report `com.taybgo.driver`, version `1.0.17`, build `21`.
- The exact local Places key is present in the iOS Dart AOT binary and every
  Android Dart AOT architecture. The production API URL and Cloudinary client
  cloud/preset settings are also present.
- Firebase production app IDs and client API keys match the native platform
  configuration and `drivertaybgo`; Android generated resources contain the
  expected Firebase settings.
- All five notification sounds match their source files. iOS sounds are under
  30 seconds.
- IPA strict/deep signing verification, Apple Distribution certificate, App Store
  profile, signing team, production APNs entitlement, disabled debugging, privacy
  plist syntax, and bundle resources passed. Runner and App framework UUIDs match
  the archive's crash symbols.
- AAB JAR signing verifies and its signing certificate matches the configured
  local upload keystore. Every bundled 64-bit native library uses load-segment
  alignment of at least 16 KB.
- `scripts/validate_release_configuration.py` checks artifact configuration without
  printing API key values; `scripts/validate_ios_release.py` checks the signed IPA.
  On macOS, signing validation needs normal host trust/keychain access outside a
  restricted shell.

## Release limits

No App Store or Play Console upload, backend deployment, live push, or payment
requests were performed. Provider key restrictions, physical-device push and
location behavior, and store acceptance remain release QA checks. Coordinate the
mobile release with the backend session-bound notification rollout.
