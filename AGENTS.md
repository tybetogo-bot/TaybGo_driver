# AGENTS.md

## Project Overview

TaybGo Driver — Flutter driver partner app for the TaybGo multi-service delivery platform.
Drivers accept food, shipping, and taxi orders, navigate to pickups/drop-offs, and track earnings.

## Build & Run

```bash
# Install dependencies
flutter pub get

# Dev flavor (points to dev.taybgo.com)
flutter run --flavor dev --target lib/main_dev.dart

# Prod flavor (points to taybgo.com)
flutter run --flavor prod --target lib/main_prod.dart

# Analyze
flutter analyze

# Generate localization files
flutter gen-l10n
```

Always specify both `--flavor` and `--target` together. The flavor controls native config (app name, bundle ID) while the target sets the Dart-side environment (base URL).

## Flavor Configuration

- `lib/core/config/app_config.dart` — Environment enum and URL mapping
- `lib/main_dev.dart` / `lib/main_prod.dart` — Flavor entry points
- `android/app/build.gradle.kts` — Android product flavors (applicationIdSuffix, resValue)
- `ios/Runner.xcodeproj/xcshareddata/xcschemes/` — Xcode schemes (dev.xcscheme, prod.xcscheme)
- `ios/Runner.xcodeproj/project.pbxproj` — iOS build configurations (Debug-dev, Debug-prod, etc.)

## Key Architecture Decisions

- **State management**: Provider + ChangeNotifier (not Riverpod, not Bloc)
- **HTTP client**: Dio with interceptors for JWT auth (auto-inject tokens, auto-refresh on 401)
- **Routing**: GoRouter with auth guard redirect logic in `core/router/app_router.dart`
- **Maps**: flutter_map with OpenStreetMap tiles (not Google Maps)
- **API constants**: `core/api/api_constants.dart` — all endpoint paths defined here, `baseUrl` comes from `AppConfig`

## Project Structure

- `lib/core/` — Shared infrastructure (API, config, providers, router, services, theme, l10n)
- `lib/features/` — Feature modules (auth, home, orders, navigation, earnings, profile, settings, etc.)
- `lib/shared/widgets/` — Reusable UI components
- `packages/phone_otp_auth_ui/` — Local package for phone/OTP authentication UI

## Important Patterns

- All providers are cleared on logout via `authProvider.onLogoutCallback` (wired in `main.dart`)
- Token refresh: Dio `QueuedInterceptor` in `api_client.dart` handles 401 → refresh → retry
- The app supports 11 locales; ARB files are in `lib/core/l10n/`
- Firebase is initialized in `main.dart` before `runApp()`

## Things to Watch Out For

- `google-services.json` must contain clients for both `com.tybetogo.driver` and `com.tybetogo.driver.dev`
- iOS `Info.plist` uses `$(APP_DISPLAY_NAME)` build variable — set per Xcode build configuration
- `flutter run` without `--flavor` will fail on Android since product flavors are defined
- Running `main.dart` directly defaults to the dev environment
