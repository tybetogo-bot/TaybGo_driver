import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/config/app_config.dart';
import 'package:teybatdriver/core/providers/order_provider.dart';
import 'package:teybatdriver/core/services/order_service.dart';
import 'package:teybatdriver/features/orders/models/order_model.dart';

class _FakeOrderService extends OrderService {
  List<OrderModel> history = [];

  @override
  Future<List<OrderModel>> getOrderHistory({int page = 1}) async => history;
}

OrderModel _order({
  required OrderStatus status,
  double driverDeliveryFee = 0,
  bool? hasDriverDeliveryFee,
}) {
  return OrderModel(
    id: '85',
    status: status,
    pickupAddress: 'Pickup',
    pickupName: 'Pickup',
    dropoffAddress: 'Drop-off',
    customerName: 'Customer',
    driverDeliveryFee: driverDeliveryFee,
    hasDriverDeliveryFee: hasDriverDeliveryFee,
    total: 4186.96,
    distance: 10,
    estimatedMinutes: 20,
  );
}

void main() {
  setUpAll(() {
    AppConfig.init(env: Environment.dev);
  });

  test('sparse history refresh does not erase the active driver fee', () async {
    final service = _FakeOrderService();
    final provider = OrderProvider(orderService: service);

    service.history = [
      _order(
        status: OrderStatus.accepted,
        driverDeliveryFee: 4132.96,
        hasDriverDeliveryFee: true,
      ),
    ];
    await provider.fetchOrderHistory();

    service.history = [
      _order(status: OrderStatus.onTheWay, hasDriverDeliveryFee: false),
    ];
    await provider.fetchOrderHistory();

    expect(provider.activeOrder?.status, OrderStatus.onTheWay);
    expect(provider.activeOrder?.driverDeliveryFee, 4132.96);
    expect(provider.activeOrder?.hasDriverDeliveryFee, isTrue);
    expect(provider.activeOrder?.formattedDriverDeliveryFee, r'$4132.96');
  });
}
