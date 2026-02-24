# TaybGo Driver

A multi-service driver partner application built with Flutter. Drivers can accept and deliver food, shipping, and taxi orders in real-time with built-in navigation, earnings tracking, and support.

## Features

### Core

- **OTP Authentication** - Phone number verification with JWT token management and automatic refresh
- **Driver Registration** - Multi-step application form with profile info, vehicle details, and document uploads
- **Order Management** - Accept/reject incoming orders, track active deliveries, and view order history
- **Real-Time Navigation** - Turn-by-turn directions via OpenStreetMap with live location tracking
- **Earnings Dashboard** - Revenue statistics and completed order history
- **Online/Offline Toggle** - Control availability from the home screen

### Support & Onboarding

- **Interactive App Tour** - Guided walkthrough for first-time drivers using overlay highlights
- **Support Tickets** - Create and track support requests with priority levels and threaded messages
- **Knowledge Base** - Searchable help articles organized by category
- **Push Notifications** - Firebase Cloud Messaging for order alerts and updates

### Settings

- **Theme Switching** - Light, Dark, and System-default modes
- **11 Languages** - English, German, French, Arabic (RTL), Luxembourgish, Italian, Dutch, Swedish, Norwegian, Danish, Finnish
- **Notification Preferences** - Configurable alert settings

## Architecture

```
lib/
├── main.dart
├── core/
│   ├── api/              # Dio HTTP client, endpoints, token storage
│   ├── constants/        # Route definitions
│   ├── l10n/             # ARB localization files & generated classes
│   ├── models/           # Shared data models
│   ├── providers/        # ChangeNotifier state management
│   ├── router/           # GoRouter config with auth guards
│   ├── services/         # Business logic (auth, orders, location, FCM)
│   └── theme/            # Colors, typography, Material theme
└── features/
    ├── auth/             # Phone & OTP screens
    ├── onboarding/       # Welcome walkthrough
    ├── application/      # Driver registration & pending approval
    ├── home/             # Dashboard
    ├── orders/           # Order list & detail
    ├── navigation/       # Map & turn-by-turn directions
    ├── earnings/         # Revenue stats
    ├── profile/          # View & edit profile
    ├── settings/         # Theme, language, notifications
    ├── notifications/    # Notification history
    ├── support/          # Ticketing system
    ├── knowledge_base/   # Help articles
    └── tour/             # Interactive guided tour
```

**State Management:** Provider with ChangeNotifier
**Navigation:** GoRouter with authentication guards and deep linking
**HTTP:** Dio with interceptors for automatic token injection and refresh
**Backend:** REST API at `taybat-backend-dev.onrender.com`

---

## Theming & Design System

The app uses Material 3 with a custom design system defined in `lib/core/theme/`.

### Color Palette

| Token | Light | Dark | Hex |
|-------|-------|------|-----|
| **Primary** | Green accent | Green accent | `#00C853` |
| **Primary Surface** | Light green fill | - | `#E8F5E9` |
| **Background** | White | Pure black | `#FFFFFF` / `#000000` |
| **Surface** | Light gray | Dark gray | `#F5F5F5` / `#1A1A1A` |
| **Border** | Gray | Dark gray | `#E0E0E0` / `#333333` |
| **Text** | Near-black | White | `#1A1A1A` / `#FFFFFF` |
| **Text Secondary** | Medium gray | Light gray | `#666666` / `#999999` |
| **Text Hint** | Faded gray | Dark gray | `#AAAAAA` / `#666666` |

**Status colors** (shared across themes):

| Status | Color | Hex |
|--------|-------|-----|
| Error | Red | `#E53935` |
| Success | Green | `#00C853` |
| Warning | Amber | `#FFB300` |
| Info | Blue | `#2196F3` |
| Online | Green | `#00C853` |
| Offline | Gray | `#999999` |

### Typography

All text styles are defined in `AppTextStyles` with no custom fonts -- the system default is used.

| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| `h1` | 28 | 600 | 1.2 | Page titles |
| `h2` | 22 | 600 | 1.25 | Section headers |
| `h3` | 18 | 600 | 1.3 | Card titles |
| `h4` | 16 | 600 | 1.3 | Subsections |
| `body` | 16 | 400 | 1.5 | Primary content |
| `bodyMedium` | 14 | 400 | 1.5 | Secondary content |
| `bodySmall` | 13 | 400 | 1.5 | Compact text |
| `label` | 14 | 500 | 1.2 | Form labels, buttons |
| `labelSmall` | 12 | 500 | 1.2 | Tags, badges |
| `caption` | 12 | 400 | 1.3 | Timestamps, metadata |
| `number` | 24 | 600 | 1.1 | Stats, counts |
| `numberSmall` | 18 | 600 | 1.2 | Inline numbers |
| `priceLarge` | 32 | 700 | 1.1 | Earnings, totals |

### Spacing

| Token | Value |
|-------|-------|
| `spacingXS` | 4 |
| `spacingS` | 8 |
| `spacingM` | 16 |
| `spacingL` | 24 |
| `spacingXL` | 32 |

### Border Radius

| Token | Value |
|-------|-------|
| `radiusSmall` | 8 |
| `radiusMedium` | 12 |
| `radiusLarge` | 16 |
| `radiusFull` | 100 |

### Component Theming

- **Buttons** - Full-width (52px height), zero elevation, 12px radius. Primary buttons use green background; outlined buttons use theme border color.
- **Inputs** - Filled background (surface color), no border by default, green focus ring at 1.5px, 12px radius.
- **App Bar** - Flat (zero elevation), left-aligned titles, 18px semibold.
- **Bottom Nav** - Fixed type, zero elevation, green selected color.
- **Dividers** - 1px, theme border color.
- **Dark mode** - True black (`#000000`) background for OLED screens; dark surface cards at `#1A1A1A`.

---

## Localization

String resources are in `lib/core/l10n/` using ARB files with the `intl` package. The generated `AppLocalizations` class provides type-safe access to all translated strings.

| Code | Language |
|------|----------|
| `en` | English |
| `de` | German |
| `fr` | French |
| `ar` | Arabic (RTL) |
| `lb` | Luxembourgish |
| `it` | Italian |
| `nl` | Dutch |
| `sv` | Swedish |
| `nb` | Norwegian Bokmal |
| `da` | Danish |
| `fi` | Finnish |

The selected locale is persisted via `SharedPreferences` and managed by `LocaleProvider`.

---

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.10.4+ / Dart |
| State | Provider + ChangeNotifier |
| Routing | GoRouter |
| HTTP | Dio |
| Auth | OTP + JWT (flutter_secure_storage) |
| Maps | flutter_map (OpenStreetMap) |
| Location | Geolocator |
| Push Notifications | Firebase Cloud Messaging + flutter_local_notifications |
| Animations | Lottie |
| Onboarding Tour | tutorial_coach_mark |
| Markdown | flutter_markdown |
| SVG | flutter_svg |
| i18n | intl + ARB files |

## Platforms

- **Android** (minSdk 21)
- **iOS**
- **Web** (limited -- no Firebase)

## Getting Started

### Prerequisites

- Flutter SDK ^3.10.4
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode for mobile builds
- Firebase project configured for FCM (iOS/Android)

### Setup

```bash
# Install dependencies
flutter pub get

# Generate localization files (if needed)
flutter gen-l10n

# Generate launcher icons
dart run flutter_launcher_icons

# Run on a connected device
flutter run
```

### Environment

The app connects to the development backend at `https://taybat-backend-dev.onrender.com/api`. API endpoints are defined in `lib/core/api/api_constants.dart`.

## Auth Flow

1. Driver enters phone number
2. OTP is sent via backend SMS
3. Driver verifies OTP and receives JWT access + refresh tokens
4. New drivers are routed to the registration form (profile, vehicle, documents)
5. Registration is reviewed by admin; driver sees a pending approval screen
6. Once approved, the driver accesses the full dashboard

Tokens are stored in `flutter_secure_storage` and automatically refreshed by a Dio interceptor on 401 responses.

## License

Proprietary. All rights reserved.
