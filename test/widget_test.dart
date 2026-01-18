import 'package:flutter_test/flutter_test.dart';

import 'package:teybatdriver/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TybeToGoDriverApp());
    await tester.pumpAndSettle();
  });
}
