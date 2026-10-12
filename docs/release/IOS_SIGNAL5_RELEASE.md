# Driver signal 5 release

October 12, 2026. Version 1.0.16, build 20.

## Fix

Build 19 bundled only signal_1.wav through signal_3.wav even though the app supports five repeats and defaults to five. Added existing signal_4.wav and signal_5.wav to Xcode file references, the Runner group, and Copy Bundle Resources. Release validation now requires all five sounds. Signal 5 is a 6.146-second PCM WAV, within [Apple’s notification sound duration limit](https://developer.apple.com/documentation/usernotifications/unnotificationsound).

The backend previously omitted Driver APNs sound. [Backend PR #87](https://github.com/tybetogo-bot/backend/pull/87) requests aps.sound=signal_5.wav for Driver support and order alerts and preserves the existing Seller sound. The backend PR targets current production main; it has not been merged or deployed. Background remote sound does not read device-local repeat preferences; the requested backend behavior is explicitly signal 5. Foreground notifications continue to use the existing local sound preference, whose default is five repeats.

## Verification

47 Driver Flutter tests passed. Eight isolated backend Firebase tests passed, including actual SDK payload serialization with mocked sends and existing Seller sound coverage. Signature, bundle identity, production APNs entitlement, all five sound resources, and matching crash symbols are checked against the exported build 20 IPA. All exported IPA checks passed: com.taybgo.driver, team Z8ZLXJ9696, Apple Distribution signature, App Store profile, production APNs, and all five PCM sound files under 30 seconds. The signal 5 bytes match the source sound. Matching crash symbol UUIDs and compiled Places configuration passed. Static analysis found no issues. Artifacts and checksums are in releases/2026-10-12/driver-1.0.16-build20/.

## Remaining steps

Upload and install build 20, then merge/deploy backend PR #87 with separate deployment authorization. Verify support and incoming-order sounds on an iPhone while foreground, background and locked. iOS Sounds permission, Silent Mode and Focus still apply. No notifications were sent and no Apple upload or backend deployment was performed. Unrelated existing artifact deletions were preserved; credentials remain in ignored local build configuration.
