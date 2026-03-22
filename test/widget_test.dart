import 'package:flutter_test/flutter_test.dart';

import 'package:teybatdriver/core/config/app_config.dart';
import 'package:teybatdriver/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    if (!AppConfig.isInitialized) {
      AppConfig.init(env: Environment.dev);
    }

    await tester.pumpWidget(TaybGoDriverApp());
    await tester.pump();
  });
}
