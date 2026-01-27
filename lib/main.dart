import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

late final GoRouter _router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
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
