import 'dart:ui' show SemanticsAction;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/l10n/app_localizations.dart';
import 'package:teybatdriver/features/home/widgets/notification_unread_pill.dart';

Widget preview(
  ValueNotifier<int> count, {
  bool reduceMotion = false,
  bool rtl = false,
  VoidCallback? onPressed,
}) => MaterialApp(
  locale: Locale(rtl ? 'ar' : 'en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: MediaQuery(
      data: MediaQueryData(disableAnimations: reduceMotion),
      child: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: count,
          builder: (_, value, _) => NotificationUnreadPill(
            unreadCount: value,
            onPressed: onPressed ?? () {},
          ),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('opening the inbox does not mark notifications read', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final count = ValueNotifier(3);
    var opened = 0;
    await tester.pumpWidget(preview(count, onPressed: () => opened++));
    expect(find.text('3 new'), findsOneWidget);
    expect(
      tester
          .getSemantics(find.byType(NotificationUnreadPill))
          .getSemanticsData()
          .hasAction(SemanticsAction.tap),
      true,
    );
    expect(
      find.byKey(const ValueKey('notification-unread-dot')),
      findsOneWidget,
    );
    await tester.tap(find.text('3 new'));
    expect(opened, 1);
    expect(count.value, 3);
    count.value = 0;
    await tester.pumpAndSettle();
    expect(find.text('All read'), findsOneWidget);
    expect(find.byKey(const ValueKey('notification-unread-dot')), findsNothing);
    count.dispose();
    semantics.dispose();
  });

  testWidgets('unread count caps at 99+ and arrival animation settles', (
    tester,
  ) async {
    final count = ValueNotifier(99);
    await tester.pumpWidget(preview(count));
    count.value = 104;
    await tester.pump();
    expect(find.text('99+ new'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 150));
    final bell = tester.widget<Transform>(
      find
          .ancestor(
            of: find.byIcon(Icons.notifications_none_rounded),
            matching: find.byType(Transform),
          )
          .first,
    );
    expect(bell.transform.isIdentity(), false);
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);
    expect(find.text('99+ new'), findsOneWidget);
    count.dispose();
  });

  testWidgets('reduced motion skips arrival animation', (tester) async {
    final count = ValueNotifier(0);
    await tester.pumpWidget(preview(count, reduceMotion: true));
    count.value = 4;
    await tester.pump();
    expect(find.text('4 new'), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 0);
    count.dispose();
  });

  testWidgets('Arabic pill fits a narrow header with large text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.dark(),
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
            child: Center(
              child: SizedBox(
                width: 280,
                child: Row(
                  children: [
                    const SizedBox(width: 44),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'اسم السائق',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 40),
                    const SizedBox(width: 8),
                    NotificationUnreadPill(unreadCount: 104, onPressed: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('99+ جديدة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
