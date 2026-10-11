# TaybGo Driver iOS release readiness

Prepared October 11, 2026. Xcode automatic provisioning and App Store IPA export succeeded. Final archive/package evidence is recorded below; physical-device and TestFlight readiness remain unverified.

## App and source

- Repository: `/Users/abdulelahalsbiei/Developer/taybgo/TaybGo_driver`.
- Work branch: `codex/driver-ios-release-readiness`.
- Starting source: `d9a6e24b116213db9c1597373cc48009da5c981a` on `codex/fix-edit-profile-lifecycle`, including release `1.0.16+18` and the native Places compatibility fallback.
- Fetched `origin/dev`: `d42b6b1` (includes merged iOS identity PR #10). Its source change relative to the common ancestor is the iOS bundle ID; the release source preserves the local release and Places commits.
- Existing deleted release artifacts were preserved and are excluded from this work's commits.
- Current version/build: `1.0.16 (18)`. App Store Connect build history has not been checked; do not assume build 18 is unused.
- Production: `com.taybgo.driver`, display name `TaybGo Driver`, `lib/main_prod.dart`, `https://taybgo.com/api`.
- Development: `com.taybgo.driver.dev`, display name `TaybGo Driver Dev`, `lib/main_dev.dart`, `https://dev.taybgo.com/api`.
- Apple team in source: `Z8ZLXJ9696`, supplied by the owner on October 11; automatic provisioning and distribution export have now succeeded.
- Toolchain used: Flutter 3.47.2 / Dart 3.13.2; Xcode 27.0 (27A266a).
- Minimum iOS: 15.0. The installed Flutter engine's generated podspec requires 15.0; the previous 13.0 target failed dependency resolution.

## Completed configuration and client fixes

- Added shared `dev`/`prod` schemes and matching Debug/Profile/Release configurations, flavor xcconfigs, names, IDs and Dart entry points.
- Linked push entitlements in every Runner configuration and declared Push Notifications/Background Modes capabilities. Existing location/fetch/remote-notification background modes remain.
- Added Firebase configuration selection with a bundle-ID assertion. The chosen file is copied into the app as `GoogleService-Info.plist`.
- Added notification WAV resources and native permission-purpose localization in all 11 supported locales.
- Completed the scene manifest and moved plugin registration/location channel creation to `didInitializeImplicitFlutterEngine`.
- Added APNs-readiness polling and device-registration retries; eliminated duplicate token-refresh listeners and guarded session changes.
- Logout unregisters the device before clearing auth, stops registration retries/listeners, invalidates the local FCM token and clears delivered notifications. Cleanup failures remain non-blocking; device/account switching still needs live QA.
- Notification taps wait for authentication and a rendered navigation frame. Order updates open their order; new offers open the dispatch home. Unknown types use the home fallback.
- Release builds suppress debug diagnostics containing request/account data; Dio body logging is debug-only. Crashlytics error reporting remains enabled in release.
- Updated five Dart packages required by this Flutter SDK's constraints: intl, matcher, meta, test_api and vector_math. Other application/plugin versions were retained.
- Recorded CocoaPods and Swift package locks. SwiftPM handles supported plugins; CocoaPods handles `flutter_local_notifications` and `flutter_secure_storage`. Flutter warns that those two plugins lack SwiftPM support; this is not an error with the installed version.

## Firebase and backend evidence

Project: `drivertaybgo`, sender/project number `527527512549`.

| Registration | Bundle ID | Firebase app ID |
| --- | --- | --- |
| Production | `com.taybgo.driver` | `1:527527512549:ios:e08595c6813c6ac8d1c70c` |
| Development | `com.taybgo.driver.dev` | `1:527527512549:ios:11c5c441b1fb2de0d1c70c` |

Both registrations were created and verified in the signed-in Firebase console. Previous `com.tybetogo.*` registrations were retained. The production plist was downloaded from Firebase; the development plist uses the downloaded project's configuration and the new development bundle/app IDs verified in the console because its download did not complete. Dart/native values agree.

Firebase Cloud Messaging API v1 is enabled. The owner supplied APNs key ID `5TTLPZXPX6` for team `Z8ZLXJ9696`, supporting sandbox and production. The production APNs slot for `com.taybgo.driver` was verified saved in Firebase with these IDs after the owner uploaded it. Its development/sandbox slot is empty; both slots for `com.taybgo.driver.dev` are also empty. The private `.p8` key remains outside the repository. Actual delivery still requires physical-device verification.

Read-only inspection of local backend commit `4af71211b227e547626b91b9620625f96749e14b` found:

- Authenticated `POST /api/notifications/device` registers/reassigns the token.
- Authenticated `DELETE /api/notifications/device` with `{token: ...}` idempotently deactivates only the user's token. The client now uses this contract.
- Driver registration intentionally deactivates other driver tokens; multi-device behavior differs from customer accounts.
- Driver events use the role-specific driver Firebase sender; invalid tokens are deactivated.

This source inspection does not prove the deployed endpoint or sender credentials match. No backend changes or deployment occurred.

Production public configuration was fetched without account credentials. It requires password login for driver/seller/admin, enables OTP for customers, and does not force an update. It returns policy/support paths under the production host: `/privacy-policy/`, `/terms-and-conditions/`, `/contact/`.

## Validation completed

- `flutter test --no-pub`: **47 tests passed**, including routing, token-session/logout and DELETE transport regressions.
- `flutter analyze --no-pub`: **no issues**.
- Production unsigned device build succeeded:

```sh
flutter build ios --release --no-codesign --no-pub \
  --flavor prod --target lib/main_prod.dart
```

- App bundle: `build/ios/iphoneos/Runner.app` (reported 29.9 MB).
- Package inspector: `scripts/validate_ios_release.py`.
- Report: `build/ios/release-readiness/unsigned-validation-report.json`.
- Verified app ID/name, native Firebase registration, scene manifest and compiled Runner SceneDelegate, three sounds, Flutter assets, location/camera/photo purposes, 11 localized permission files, arm64 binaries and **29 parseable privacy manifests**.
- All five embedded frameworks contain arm64. Firebase and other Swift package plugins are linked statically into Runner.
- Available Runner and App dSYM UUIDs match their binaries. These belong to this unsigned validation build and must be regenerated/checked for the final signed export.
- The 1024px App Store icon has no alpha channel.
- A signed Release build without the required Places define is rejected by `scripts/check_ios_release_config.sh`.

The initial unsigned build omitted the Places key. After the owner supplied it, a second production build succeeded using `--dart-define-from-file=releases/config/ios-prod.json`. The local file is ignored by Git and mode 0600; the build script uses it by default. Google Places API (New) autocomplete returned five suggestions, and details returned an address and coordinates. The exact key was verified present in the compiled App framework without logging it. Evidence: `places-api-validation.json` and `unsigned-with-places-validation.json` in `build/ios/release-readiness/`. This verifies API access and compilation, not physical-device signup or a distributable release. The signed export checks are recorded below. Physical-device launch and TestFlight evidence remain unverified.

Initially, the keychain had a valid Apple Development identity for team `Z8ZLXJ9696` but no matching distribution identity. Xcode automatic provisioning subsequently obtained the required distribution signing assets and exported a correctly signed App Store IPA. No unrelated certificate was revoked.

Existing Flutter localization gaps remain: Arabic has 81 untranslated messages; nine other non-English locales have 156 each and use the template fallback. Native permission strings were added separately; the full app is not claimed to be fully translated.

## Release and device follow-up

1. Verify native signup/address selection on a physical iPhone using the supplied Places configuration. Direct autocomplete/details verification succeeded; actual app/device behavior remains unverified.
2. Verify App Store record and that build 18 is unused before upload. Bundle ID, team, push capability and distribution signing/provisioning passed exported-package validation. Align `pubspec.yaml` and `ReleaseInfo` if Apple build history requires a new version/build.
3. Production APNs credentials are saved and verified for the production registration. Configure the still-empty sandbox slot and development registration when development push testing is required, confirming scope/topic compatibility. Production device delivery remains unverified.
4. App Store IPA archive/export completed using production flavor/target and local Places defines. Export method is `app-store-connect`, destination `export`, automatic signing, team `Z8ZLXJ9696`, and `manageAppVersionAndBuildNumber=false`. No upload was requested.
5. Preserve the exported IPA, matching archive/dSYMs and validation report/checksums together. Revalidate any subsequent rebuild/export.
6. Test driver password login/signup, session restore, dispatch acceptance/rejection, pickup/drop-off/navigation, background location, earnings, document uploads, deletion and denied permissions on a physical iPhone.
7. Test Firebase and real backend notifications in foreground/background/cold start, permission denied, token refresh/reinstall and logout/account switching; confirm the opened destination and locale/sound/badges.
8. Verify deployed Firebase sender project/credentials and token ownership/cleanup behavior. Device token registration or a successful send response alone is not delivery evidence.
9. Check truthful privacy disclosures/reasons, policy/support pages, reviewer access, export compliance, screenshots and other store metadata. Privacy plist syntax alone is insufficient.
10. Upload only when authorized; confirm Apple processing, then perform TestFlight QA. Submission/publication are separate actions.

For the final signed build, with verified Apple export options and the ignored local production defines file (or an environment key override):

```sh
sh scripts/build_ios_store.sh VERSION UNUSED_BUILD PATH_TO_EXPORT_OPTIONS_PLIST
```

Apple automatic provisioning, archive and App Store IPA export were performed. No Apple upload, App Review submission, publication, backend deployment or outbound messages occurred.

## Final signed App Store artifact

- IPA: `releases/2026-10-11/TaybGo-Driver-1.0.16+18-AppStore.ipa` (27,174,269 bytes).
- Build source commit: `b9d6b5f`; production version/build `1.0.16+18`.
- Automatic Xcode provisioning created `iOS Team Store Provisioning Profile: com.taybgo.driver`, UUID `042f50dc-807e-4db4-9bdc-28dc6493fb92`, team `Z8ZLXJ9696`, expiry October 10, 2027 at 19:52:17 UTC.
- `signed-ipa-validation.json`: all checks passed, including Apple Distribution certificate, strict signature, exact team/application identity, App Store profile, unexpired profile, production push entitlement, disabled debugging, resources and privacy plist syntax.
- All five embedded frameworks are arm64. Archive dSYMs match all six executable images (Runner and five frameworks); two objective_c symbol bundles have the same verified UUID.
- Runner UUID: `71F0A1D3-4DA4-3F99-A197-7B6D73BE5F66`; App UUID: `85AA7E27-0A13-2B93-DB3E-F2C22BA20B1E`.
- Places key inclusion was verified in the final App framework without exposing the value in reports.
- Replaced Flutter's template launch image with the existing TaybGo artwork; final archive has no template icon/launch-image validation warning.
- Preserved Xcode archive ZIP, dSYMs ZIP, export options, build log, source/config manifest and SHA-256 checksums alongside the IPA. Credentials are excluded from reports/source control.
- This is an exported App Store distribution IPA. It has not been uploaded or accepted by Apple, and does not establish physical-device/TestFlight QA or that build 18 is unused.
