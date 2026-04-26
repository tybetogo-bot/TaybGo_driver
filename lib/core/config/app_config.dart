import 'package:shared_preferences/shared_preferences.dart';

/// Application environment configuration.
///
/// Each flavor (dev / prod) calls [AppConfig.init] once from its
/// dedicated `main_<flavor>.dart` entry-point before `runApp()`.
enum Environment { dev, prod }

class AppConfig {
  static const _environmentStorageKey = 'app_environment';
  static Environment? _environment;

  static Environment get environment => _environment!;
  static bool get isInitialized => _environment != null;
  static bool get isDev => _environment == Environment.dev;
  static bool get isProd => _environment == Environment.prod;

  static late String baseUrl;
  static late String appName;

  /// Must be called once at app startup before any network call.
  static void init({required Environment env}) {
    _environment = env;
    switch (env) {
      case Environment.dev:
        baseUrl = 'https://dev.taybgo.com/api';
        appName = 'TaybGo Driver Dev';
      case Environment.prod:
        baseUrl = 'https://taybgo.com/api';
        appName = 'TaybGo Driver';
    }
  }

  static Future<void> persistEnvironment() async {
    if (!isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_environmentStorageKey, environment.name);
  }

  static Future<void> ensureInitializedFromStorage() async {
    if (isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getString(_environmentStorageKey);
    final env = Environment.values.cast<Environment?>().firstWhere(
      (candidate) => candidate?.name == storedValue,
      orElse: () => null,
    );

    init(env: env ?? Environment.dev);
  }
}
