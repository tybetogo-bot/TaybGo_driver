# Driver iOS scene, push and Places audit

October 11, 2026. Existing release-artifact deletions were preserved. No live settings, roles, tokens or credentials were changed; no notifications were sent and no Apple upload was performed.

## Confirmed issue and correction

The previous Driver release locked firebase_messaging 15.2.10 while adopting Flutter's UIScene lifecycle. FlutterFire added scene support in 16.1.0 and subsequent initialization fixes, including early notification delegate configuration in 16.5.0 and APNs registration fixes in 16.7.0. Upgraded Messaging to 16.7.0, Core to 4.15.0 and Crashlytics to 5.4.0. Native Firebase SDK resolution is recorded in package locks.

AppDelegate now calls FLTFirebaseMessagingPlugin.configureNotificationCenterDelegate() before launch returns, following the official package example/header. Native Firebase configuration is guarded against duplicate initialization. Removed manual notification-center delegate/APNs registration/token assignment so FlutterFire owns those callbacks. Preserved implicit-engine plugin registration, the location bridge and local-notification background plugin registration. Firebase method swizzling remains enabled.

Sources: [FlutterFire changelog](https://pub.dev/packages/firebase_messaging/changelog), [Flutter FCM setup](https://firebase.google.com/docs/cloud-messaging/flutter/get-started), and the published 16.7.0 package's iOS AppDelegate example and public plugin header.

## Production Firebase and live backend

Production identity remains com.taybgo.driver, Apple team Z8ZLXJ9696, Firebase project drivertaybgo, sender 527527512549, Firebase app 1:527527512549:ios:e08595c6813c6ac8d1c70c. The Firebase console confirms a saved production APNs credential with the expected key/team IDs. Sandbox/development credentials are still absent; no console settings were changed.

The Render backend-prod dashboard confirms deployed source 4af71211b227e547626b91b9620625f96749e14b. A Django query inside a read-only database transaction confirmed Firebase enabled and the driver sender credential project drivertaybgo; no private key or token value was printed.

The user clarified that Driver has not been tested. The supplied account exists and is active but has only the customer role. Its existing active iOS token was created April 18 and last seen June 30, 2026; its web token is inactive. The deployed routing function selects the customer sender for this account. This is not an active Driver registration or Driver-project delivery proof. The registry does not store the token's Firebase project, and opaque FCM token ownership cannot be verified from the database alone without an authorized provider operation. No provider send/validation was performed. Driver QA requires a driver-role account and a fresh registration from this build.

The visible seven-day Render application logs include successful device registrations (HTTP 200) and an unregister request (HTTP 204). Those lines do not identify the account or Firebase project and therefore cannot prove Driver delivery. No registration failure was identified in the inspected results.

Client registration uses authenticated POST /api/notifications/device with device_type ios. Retries wait for APNs readiness; existing session guards, refresh listener cleanup and logout unregister behavior are covered by tests. Backend registration reassigns the token to the authenticated user and driver registration deactivates other driver tokens. These settings were inspected without mutation.

## Places and release configuration

The supplied production key is stored in an ignored, mode-0600 local defines JSON. Actual Places API (New) autocomplete returned five suggestions; details returned a formatted address and latitude/longitude using the same endpoint/field masks as the app. The key is never printed in reports or committed. API access is confirmed; console restrictions need the supplied key's owning project to be matched. The inspected Maps Platform API Key in My First Project is a different key, so its restrictions must not be attributed to this build's key.

The existing signed Release Xcode guard rejects missing/empty Places defines. Direct checks confirmed missing and empty fail, valid-shaped defines pass, and unsigned source-validation builds remain allowed. The production IPA wrapper requires a local defines file or explicit environment key. Physical-device signup suggestions remain untested.

## Validation and artifact

47 Flutter tests passed after the Firebase upgrade. Static analysis found no issues. The user confirmed no uploaded Driver build above 18 and selected build 19. pubspec and ReleaseInfo are aligned to 1.0.16+19; the release date is October 11, 2026. The signed production archive and App Store export completed successfully. The exported IPA confirms version 1.0.16, build 19, bundle com.taybgo.driver, team Z8ZLXJ9696, an Apple Distribution signature, a valid App Store profile, aps-environment=production and get-task-allow=false. Strict deep signature verification passed. All exported Mach-O binaries have matching archive dSYM UUIDs. The supplied Places key is present in the compiled App framework, the early Messaging delegate selector is compiled, and Firebase swizzling is enabled. Privacy manifest plist syntax passed; this does not certify disclosure accuracy.

Final artifacts are under releases/2026-10-11/driver-1.0.16-build19/: the IPA, archive ZIP, dSYMs ZIP, signature/configuration/symbol validation reports, Places endpoint results, build log and SHA256SUMS. Artifact verification completed October 12, 2026. Build 18 remains preserved separately. Apple acceptance and physical-device behavior are unverified. The supplied Places key’s console restrictions remain unverified until its owning Google Cloud project is identified.

## Real-device checks remaining

Use a driver-role account. Verify permission prompt and APNs/FCM registration, then check that its active ios token is associated with that account and drivertaybgo. With separate authorization, verify backend foreground/background/cold-start delivery, tap routing, badge/sound/locale, denial/reinstall/token-refresh and logout/account switching. Verify Places suggestions/address selection on the actual iPhone, along with driver dispatch and background location. No token registration or successful send response alone proves displayed delivery.
