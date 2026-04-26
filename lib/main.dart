import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
import 'core/providers/earnings_provider.dart';
import 'core/router/app_router.dart';
import 'core/services/fcm_service.dart';
import 'core/constants/route_constants.dart';
import 'features/support/application/support_provider.dart';

GoRouter? _router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Default to prod if main.dart is launched directly (no flavor entry-point)
  if (!AppConfig.isInitialized) {
    AppConfig.init(env: Environment.prod);
  }
  await AppConfig.persistEnvironment();

  await initializeDateFormatting();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[Main] Firebase initialized');

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

  // Initialize auth provider before running app
  final authProvider = AuthProvider();
  await authProvider.initialize();

  // Initialize tour provider
  final tourProvider = TourProvider();
  await tourProvider.init();

  // Create router once with the auth provider
  _router = AppRouter.createRouter(authProvider);

  runApp(
    TaybGoDriverApp(authProvider: authProvider, tourProvider: tourProvider),
  );

  fcmService.onNotificationTap = _handleNotificationTap;
}

void _handleNotificationTap(Map<String, dynamic> data) {
  final router = _router;
  if (router == null) return;

  final orderId = _extractNotificationOrderId(data);
  final route = orderId != null
      ? RouteConstants.orderDetailPath(orderId)
      : RouteConstants.orders;

  router.go(route);
}

String? _extractNotificationOrderId(Map<String, dynamic> data) {
  final value = data['order_id'] ?? data['orderId'] ?? data['id'];
  final orderId = value?.toString().trim();
  if (orderId == null || orderId.isEmpty) {
    return null;
  }
  return orderId;
}

class TaybGoDriverApp extends StatelessWidget {
  final AuthProvider authProvider;
  final TourProvider tourProvider;

  TaybGoDriverApp({
    super.key,
    AuthProvider? authProvider,
    TourProvider? tourProvider,
  }) : authProvider = authProvider ?? AuthProvider(),
       tourProvider = tourProvider ?? TourProvider();

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
          );
        },
      ),
    );
  }
}
