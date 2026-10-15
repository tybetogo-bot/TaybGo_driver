# Driver session and push cleanup

October 14, 2026. Based on Driver `88ad037` and the contract in backend PR #89
(merged as `3514abdf85bc08236dde3b22a930a368d8f69d9b`).

## Changes

- API clients share a login generation, refresh operation, credential write queue,
  and rejection callback. Late responses cannot write credentials, retry a request
  as another account, or clear a newer login. Protected requests without usable
  credentials are cancelled. A failed retry completes without re-entering the
  queued error interceptor.
- HTTP 401 attempts refresh once. Definitive refresh rejection forces local
  cleanup; transport and server failures preserve saved credentials. Ordinary
  permission-related 403 responses do not force logout.
- Manual and forced logout invalidate callbacks immediately, clear credentials
  and account state, and await the same local cleanup. Manual logout attempts
  session-scoped unregister, offline sync, and backend logout while credentials
  remain usable. Remote cleanup uses a bounded wait; local SDK deletion does not
  release the next login until its actual future completes. Late remote cleanup
  cannot delete the next login's credentials.
- FCM permission/APNs/token work and token deletion are serialized and fenced.
  Deletion is attempted even when disabling auto-init fails. Foreground display
  and taps are gated on the active push session; logout waits for pending local
  presentation before clearing delivered alerts. Background local notifications
  and actions require saved credentials. Already dispatched OS remote alerts
  cannot be recalled.
- Push initializes at the auth boundary after restoration/login, including before
  the home screen opens. Inbox, profile, order, earnings, support, and location
  results cannot repopulate cleared account state. Tour reset is awaited. Device
  notification sound/repeat preferences are preserved.
- Existing Driver notification sound resources and Android channels are retained.

## Validation

- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub`: 74 tests passed, including offline refresh, replaced
  sessions, late refresh success/rejection, shared refresh rotation, retry 401,
  delayed SDK deletion, failed auto-init disable, late permission lookup, rejected
  unregister, stale inbox/profile/orders, singleton location cache invalidation, and manual/forced logout followed by
  re-login. All auth/push race tests use local fakes; no live sends or payments.
- Production CORS preflight permits `http://localhost:3002`.
- Local web run uses the production entry point and the existing ignored local
  Places definitions:

```sh
flutter run --no-pub --release -d web-server --flavor prod \
  --target lib/main_prod.dart --web-hostname localhost --web-port 3002 \
  --dart-define-from-file=releases/config/ios-prod.json
```

Flutter web does not use native flavors; `main_prod.dart` selects
`https://taybgo.com/api`. Never commit the local definitions file or its values.

## Remaining release verification

Coordinate a new signed Android/iOS release with the backend session migrations
and deployment. Two physical devices, background/locked push delivery, offline
SDK behavior, and production PostgreSQL concurrency remain device/rollout checks.
No store upload, production backend deployment, live push, or payment requests
were performed by this work.
