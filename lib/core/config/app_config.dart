/// Application environment configuration.
///
/// Each flavor (dev / prod) calls [AppConfig.init] once from its
/// dedicated `main_<flavor>.dart` entry-point before `runApp()`.
enum Environment { dev, prod }

class AppConfig {
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
        appName = 'Driver Dev';
      case Environment.prod:
        baseUrl = 'https://taybgo.com/api';
        appName = 'Driver';
    }
  }
}
