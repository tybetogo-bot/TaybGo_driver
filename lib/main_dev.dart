import 'core/config/app_config.dart';
import 'main.dart' as app;

Future<void> main() {
  AppConfig.init(env: Environment.dev);
  return app.main();
}
