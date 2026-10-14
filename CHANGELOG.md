# Changelog

## 1.0.17+21 — 14 October 2026

- Added an unread notification pill to the home header with a live count, coral indicator, and brief arrival animation. Supports reduced motion, dark mode, RTL, and all 11 app languages.
- Refreshes unread counts on home entry, foreground notification arrival, app resume, manual refresh, and every 30 seconds while home is mounted. Reading notifications now persists to the backend; opening the inbox does not mark everything read.
- Unified manual and forced logout cleanup. Stops push registration, clears account and location state, and waits for old FCM token deletion before a new login can generate a token.
- Prevents stale requests, token refreshes, inbox loads, and location callbacks from restoring an old account or overwriting a newer session. Offline and transient refresh failures preserve saved credentials.
- Preserves notification sound preferences and all five Driver notification sounds. Clearing the inbox no longer interrupts push registration.
- Production Android and iOS builds include the existing Places, Firebase, and document-upload client configuration.

## 1.0.16+20 — 12 October 2026

- Bundled all five iOS notification signal sounds and added release validation for each resource.
- Updated iOS release readiness and signed artifact verification documentation.
