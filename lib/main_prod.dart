import 'core/config/app_config.dart';
import 'main.dart' as app;

Future<void> main() {
  AppConfig.init(env: Environment.prod);
  return app.main();
}
