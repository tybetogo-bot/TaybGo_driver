import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/order_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/driver_provider.dart';
import 'core/providers/notification_provider.dart';
import 'core/providers/tour_provider.dart';
import 'core/router/app_router.dart';
import 'core/services/fcm_service.dart';

late final GoRouter _router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

  runApp(TybeToGoDriverApp(
    authProvider: authProvider,
    tourProvider: tourProvider,
  ));
}

class TybeToGoDriverApp extends StatelessWidget {
  final AuthProvider authProvider;
  final TourProvider tourProvider;

  const TybeToGoDriverApp({
    super.key,
    required this.authProvider,
    required this.tourProvider,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = OrderProvider();
    final driverProvider = DriverProvider();
    final notificationProvider = NotificationProvider();

    // Wire up logout callback so all providers clear on any logout
    // (including forced logout from expired tokens)
    authProvider.onLogoutCallback = () {
      driverProvider.clearProfile();
      orderProvider.clearAll();
      notificationProvider.clearAll();
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
        ChangeNotifierProvider.value(value: tourProvider),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp.router(
            title: 'TybeToGo Driver',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.systemThemeMode,
            locale: localeProvider.locale,
            supportedLocales: LocaleProvider.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
