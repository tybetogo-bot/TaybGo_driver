# TaybGo Driver - Driver Partner App

A multi-service driver partner application for the TaybGo platform. Drivers accept and deliver food, shipping, and taxi orders in real-time with built-in navigation, earnings tracking, and support.

## Quick Start

```bash
# Install dependencies
flutter pub get

# Supply a restricted Google Maps/Places key through your environment.
export GOOGLE_MAPS_API_KEY='<your-key>'

# Run dev flavor
flutter run --flavor dev --target lib/main_dev.dart \
  --dart-define=GOOGLE_MAPS_API_KEY="$GOOGLE_MAPS_API_KEY"

# Run prod flavor
flutter run --flavor prod --target lib/main_prod.dart \
  --dart-define=GOOGLE_MAPS_API_KEY="$GOOGLE_MAPS_API_KEY"
```

Or use the VSCode launch configurations: **Dev (Debug)** / **Prod (Debug)** from the Run and Debug panel.

## Flavors

| Flavor | App Name   | Base URL                  | Bundle ID                    |
|--------|------------|---------------------------|------------------------------|
| `dev`  | TaybGo Driver Dev | `https://dev.taybgo.com/api` | `com.tybetogo.driver.dev`  |
| `prod` | TaybGo Driver     | `https://taybgo.com/api`     | `com.tybetogo.driver`      |

The flavor system works across all platforms:

- **Dart**: `lib/main_dev.dart` / `lib/main_prod.dart` configure `AppConfig` before bootstrap
- **Android**: Product flavors in `build.gradle.kts` set `applicationIdSuffix` and `resValue` for app name
- **iOS**: Xcode schemes (`dev` / `prod`) with flavor-specific build configurations set `APP_DISPLAY_NAME` and `PRODUCT_BUNDLE_IDENTIFIER`

### Build Commands

```bash
# Debug
flutter run --flavor dev --target lib/main_dev.dart \
  --dart-define=GOOGLE_MAPS_API_KEY="$GOOGLE_MAPS_API_KEY"
flutter run --flavor prod --target lib/main_prod.dart \
  --dart-define=GOOGLE_MAPS_API_KEY="$GOOGLE_MAPS_API_KEY"

# Release APK
flutter build apk --flavor prod --target lib/main_prod.dart --release \
  --dart-define=GOOGLE_MAPS_API_KEY="$GOOGLE_MAPS_API_KEY"

# Release App Bundle (Play Store)
flutter build appbundle --flavor prod --target lib/main_prod.dart --release \
  --dart-define=GOOGLE_MAPS_API_KEY="$GOOGLE_MAPS_API_KEY"

# iOS (requires macOS)
flutter build ios --flavor prod --target lib/main_prod.dart --release \
  --dart-define=GOOGLE_MAPS_API_KEY="$GOOGLE_MAPS_API_KEY"
```

Android release builds validate this value before compilation. A missing or
malformed key stops the build with a clear message instead of shipping an APK
whose required address step cannot be completed.

## Features

### Core
- **OTP Authentication** - Phone number verification with JWT token management and automatic refresh
- **Driver Registration** - Multi-step form with profile, vehicle details, and document uploads (Cloudinary)
- **Order Management** - Accept/reject incoming orders, track active deliveries, view history
- **Real-Time Navigation** - Turn-by-turn directions via OpenStreetMap with live location tracking
- **Earnings Dashboard** - Revenue statistics and completed order history
- **Online/Offline Toggle** - Control availability from the home screen

### Support & Onboarding
- **Interactive App Tour** - Guided walkthrough with overlay highlights for new drivers
- **Support Tickets** - Priority-level ticketing with threaded messages
- **Knowledge Base** - Searchable help articles organized by category
- **Push Notifications** - Firebase Cloud Messaging for order alerts and updates

### Settings
- **Theme** - Light, Dark, and System-default modes (Material 3)
- **11 Languages** - EN, DE, FR, AR (RTL), LB, IT, NL, SV, NB, DA, FI
- **Notification Preferences** - Configurable alert settings

## Architecture

```
lib/
├── main.dart                # Shared bootstrap (defaults to dev if run directly)
├── main_dev.dart            # Dev entry point
├── main_prod.dart           # Prod entry point
├── core/
│   ├── api/                 # Dio HTTP client, endpoints, token storage
│   ├── config/              # AppConfig (environment, base URL, app name)
│   ├── constants/           # Route definitions
│   ├── l10n/                # ARB localization files (11 languages)
│   ├── models/              # Shared data models
│   ├── providers/           # ChangeNotifier state management
│   ├── router/              # GoRouter with auth guards
│   ├── services/            # Business logic (auth, orders, location, FCM)
│   └── theme/               # Material 3 design system
└── features/
    ├── auth/                # Phone & OTP screens
    ├── application/         # Driver registration & pending approval
    ├── home/                # Dashboard
    ├── orders/              # Order list & detail
    ├── navigation/          # Map & turn-by-turn directions
    ├── earnings/            # Revenue stats
    ├── profile/             # View & edit profile
    ├── settings/            # Theme, language, notifications
    ├── notifications/       # Notification history
    ├── support/             # Ticketing system
    ├── knowledge_base/      # Help articles
    ├── onboarding/          # Welcome screen
    └── tour/                # Interactive guided tour
```

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.10+ / Dart |
| State Management | Provider + ChangeNotifier |
| Routing | GoRouter (auth guards, deep linking) |
| HTTP | Dio (interceptors for JWT inject/refresh) |
| Auth | Phone OTP + JWT (`flutter_secure_storage`) |
| Maps | flutter_map (OpenStreetMap) |
| Location | Geolocator |
| Push Notifications | Firebase Cloud Messaging + flutter_local_notifications |
| Onboarding | tutorial_coach_mark |
| i18n | intl + ARB files |

## Auth Flow

1. Driver enters phone number
2. OTP sent via backend SMS
3. OTP verified → JWT access + refresh tokens issued
4. New drivers → registration form (profile, vehicle, documents)
5. Admin reviews → pending approval screen
6. Approved → full dashboard access

Tokens stored in `flutter_secure_storage`, auto-refreshed by Dio interceptor on 401 responses.

## Prerequisites

- Flutter SDK ^3.10.4
- Android Studio / Xcode
- Firebase project configured (FCM for iOS/Android)

## License

Proprietary. All rights reserved.
