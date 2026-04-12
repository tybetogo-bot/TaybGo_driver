import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:teybatdriver/core/l10n/framework_locale_support.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  test('Luxembourgish falls back to German for framework and intl locales', () {
    expect(
      FrameworkLocaleSupport.hasFrameworkFallback(const Locale('lb')),
      isTrue,
    );
    expect(
      FrameworkLocaleSupport.frameworkLocale(const Locale('lb')),
      const Locale('de'),
    );
    expect(
      FrameworkLocaleSupport.dateFormattingLocale(const Locale('lb')),
      'de',
    );
  });

  testWidgets('lb locale still provides Material localizations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('lb'),
        supportedLocales: const [Locale('lb')],
        localizationsDelegates: const [
          FallbackMaterialLocalizationsDelegate(),
          FallbackWidgetsLocalizationsDelegate(),
          FallbackCupertinoLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            final materialLocalizations = MaterialLocalizations.of(context);
            return Text(materialLocalizations.okButtonLabel);
          },
        ),
      ),
    );

    expect(find.text('OK'), findsOneWidget);
  });
}
