import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:teybatdriver/core/config/app_config.dart';
import 'package:teybatdriver/core/l10n/app_localizations.dart';
import 'package:teybatdriver/core/providers/driver_provider.dart';
import 'package:teybatdriver/core/providers/order_provider.dart';
import 'package:teybatdriver/features/orders/models/order_model.dart';
import 'package:teybatdriver/features/orders/screens/orders_screen.dart';

class _FakeOrderProvider extends OrderProvider {
  _FakeOrderProvider(this.orders);

  final List<OrderModel> orders;

  @override
  List<OrderModel> get orderHistory => orders;

  @override
  Future<void> fetchOrderHistory({int page = 1}) async {}
}

OrderModel _order(String id, OrderType type) {
  return OrderModel(
    id: id,
    orderType: type,
    status: OrderStatus.completed,
    pickupAddress: 'Pickup address',
    pickupName: 'Pickup',
    dropoffAddress: 'Drop-off address',
    customerName: 'Customer',
    driverDeliveryFee: 8,
    distance: 4.2,
    estimatedMinutes: 12,
  );
}

void main() {
  setUpAll(() {
    if (!AppConfig.isInitialized) {
      AppConfig.init(env: Environment.dev);
    }
  });

  testWidgets('filters order history by shipping and taxi type', (
    tester,
  ) async {
    final orderProvider = _FakeOrderProvider([
      _order('S1', OrderType.shipping),
      _order('T1', OrderType.taxi),
    ]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<OrderProvider>.value(value: orderProvider),
          ChangeNotifierProvider(create: (_) => DriverProvider()),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: OrdersScreen(),
        ),
      ),
    );

    await tester.tap(find.text('Order History'));
    await tester.pumpAndSettle();

    expect(find.text('Shipping order #S1'), findsOneWidget);
    expect(find.text('Taxi ride #T1'), findsOneWidget);

    await tester.tap(find.text('Shipping'));
    await tester.pumpAndSettle();

    expect(find.text('Shipping order #S1'), findsOneWidget);
    expect(find.text('Taxi ride #T1'), findsNothing);
  });
}
