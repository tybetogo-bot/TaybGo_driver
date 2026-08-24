import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/config/app_config.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/framework_locale_support.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/order_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/driver_provider.dart';
import 'core/providers/notification_provider.dart';
import 'core/providers/notification_settings_provider.dart';
import 'core/providers/tour_provider.dart';
import 'core/providers/public_config_provider.dart';
import 'core/providers/earnings_provider.dart';
import 'core/router/app_router.dart';
import 'core/services/fcm_service.dart';
import 'core/constants/route_constants.dart';
import 'features/support/application/support_provider.dart';
import 'shared/widgets/required_update_gate.dart';

GoRouter? _router;
_NotificationCleanupObserver? _notificationCleanupObserver;
bool _crashlyticsReady = false;

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Default to prod if main.dart is launched directly (no flavor entry-point)
    if (!AppConfig.isInitialized) {
      AppConfig.init(env: Environment.prod);
    }
    await AppConfig.persistEnvironment();

    await initializeDateFormatting();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('[Main] Firebase initialized');

    await _initializeCrashlytics();

    // Initialize FCM (permissions, channels, listeners)
    // On web, run non-blocking so a stuck permission prompt doesn't prevent app load
    final fcmService = FcmService();
    if (kIsWeb) {
      fcmService.initialize().catchError((e) {
        debugPrint('[Main] FCM web init failed: $e');
      });
    } else {
      await fcmService.initialize();
    }
    _notificationCleanupObserver = _NotificationCleanupObserver(fcmService);
    WidgetsBinding.instance.addObserver(_notificationCleanupObserver!);

    // Initialize auth provider before running app
    final authProvider = AuthProvider();
    await authProvider.initialize();

    final publicConfigProvider = PublicConfigProvider();
    await publicConfigProvider.initialize();

    // Initialize tour provider
    final tourProvider = TourProvider();
    await tourProvider.init();

    // Create router once with the auth provider
    _router = AppRouter.createRouter(authProvider);

    runApp(
      TaybGoDriverApp(
        authProvider: authProvider,
        tourProvider: tourProvider,
        publicConfigProvider: publicConfigProvider,
      ),
    );

    unawaited(fcmService.clearDeliveredNotifications());
    fcmService.onNotificationTap = _handleNotificationTap;
  }, _recordFatalError);
}

Future<void> _initializeCrashlytics() async {
  if (kIsWeb) {
    return;
  }

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    !kDebugMode || AppConfig.isProd,
  );
  _crashlyticsReady = true;

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    unawaited(FirebaseCrashlytics.instance.recordFlutterFatalError(details));
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    unawaited(
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
    );
    return true;
  };
}

void _recordFatalError(Object error, StackTrace stack) {
  debugPrint('[Main] Uncaught error: $error');

  if (kIsWeb || !_crashlyticsReady) {
    return;
  }

  unawaited(
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

void _handleNotificationTap(Map<String, dynamic> _) {
  final router = _router;
  if (router == null) return;

  unawaited(FcmService().clearDeliveredNotifications());
  router.go(RouteConstants.home);
}

class _NotificationCleanupObserver extends WidgetsBindingObserver {
  _NotificationCleanupObserver(this._fcmService);

  final FcmService _fcmService;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_fcmService.clearDeliveredNotifications());
    }
  }
}

class TaybGoDriverApp extends StatelessWidget {
  final AuthProvider authProvider;
  final TourProvider tourProvider;
  final PublicConfigProvider publicConfigProvider;

  TaybGoDriverApp({
    super.key,
    AuthProvider? authProvider,
    TourProvider? tourProvider,
    PublicConfigProvider? publicConfigProvider,
  }) : authProvider = authProvider ?? AuthProvider(),
       tourProvider = tourProvider ?? TourProvider(),
       publicConfigProvider = publicConfigProvider ?? PublicConfigProvider();

  @override
  Widget build(BuildContext context) {
    final orderProvider = OrderProvider();
    final driverProvider = DriverProvider();
    final notificationProvider = NotificationProvider();
    final notificationSettingsProvider = NotificationSettingsProvider();
    final earningsProvider = EarningsProvider();
    final supportProvider = SupportProvider();
    final router = _router ??= AppRouter.createRouter(authProvider);

    // Wire up logout callback so all providers clear on any logout
    // (including forced logout from expired tokens)
    authProvider.onBeforeLogoutCallback = () async {
      await driverProvider.markOfflineBeforeLogout();
    };
    authProvider.onLogoutCallback = () {
      driverProvider.clearProfile();
      orderProvider.clearAll();
      earningsProvider.clearAll();
      notificationProvider.clearAll();
      supportProvider.clearAll();
      tourProvider.resetTour();
    };

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider.value(value: orderProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: driverProvider),
        ChangeNotifierProvider.value(value: notificationProvider),
        ChangeNotifierProvider.value(value: notificationSettingsProvider),
        ChangeNotifierProvider.value(value: earningsProvider),
        ChangeNotifierProvider.value(value: supportProvider),
        ChangeNotifierProvider.value(value: tourProvider),
        ChangeNotifierProvider.value(value: publicConfigProvider),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp.router(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.systemThemeMode,
            locale: localeProvider.locale,
            supportedLocales: LocaleProvider.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              FallbackMaterialLocalizationsDelegate(),
              FallbackWidgetsLocalizationsDelegate(),
              FallbackCupertinoLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: router,
            builder: (context, child) =>
                RequiredUpdateGate(child: child ?? const SizedBox.shrink()),
          );
        },
      ),
    );
  }
}
