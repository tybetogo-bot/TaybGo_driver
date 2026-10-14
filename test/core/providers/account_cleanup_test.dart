import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/api/api_client.dart';
import 'package:teybatdriver/core/config/app_config.dart';
import 'package:teybatdriver/core/models/driver_profile.dart';
import 'package:teybatdriver/core/providers/driver_provider.dart';
import 'package:teybatdriver/core/providers/order_provider.dart';
import 'package:teybatdriver/core/services/driver_service.dart';
import 'package:teybatdriver/core/services/order_service.dart';
import 'package:teybatdriver/features/orders/models/order_model.dart';

class ProfileService extends DriverService {
  ProfileService() : super(apiClient: ApiClient());
  final profile = Completer<DriverProfile>();
  @override
  Future<DriverProfile> getProfile() => profile.future;
}

class OrdersService extends OrderService {
  final history = Completer<List<OrderModel>>();
  final active = Completer<OrderModel?>();
  @override
  Future<List<OrderModel>> getOrderHistory({int page = 1}) => history.future;
  @override
  Future<OrderModel?> getActiveOrder() => active.future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => AppConfig.init(env: Environment.prod));
  test(
    'late driver profile cannot restore account data after logout',
    () async {
      final service = ProfileService();
      final provider = DriverProvider(driverService: service);
      final load = provider.fetchProfile();
      provider.clearProfile();
      service.profile.complete(
        DriverProfile(id: 1, phone: '+15550000000', isOnline: true),
      );
      await load;
      expect(provider.profile, isNull);
      expect(provider.isOnline, false);
      expect(provider.isLoading, false);
      provider.dispose();
    },
  );
  test(
    'late order history and active order cannot restore a logged-out account',
    () async {
      final service = OrdersService();
      final provider = OrderProvider(orderService: service);
      final history = provider.fetchOrderHistory();
      final active = provider.checkActiveOrder();
      provider.clearAll();
      final order = OrderModel(
        id: '85',
        status: OrderStatus.accepted,
        pickupAddress: 'Pickup',
        pickupName: 'Pickup',
        dropoffAddress: 'Drop-off',
        customerName: 'Old account',
        total: 10,
        distance: 1,
        estimatedMinutes: 5,
      );
      service.history.complete([order]);
      service.active.complete(order);
      await history;
      await active;
      expect(provider.orderHistory, isEmpty);
      expect(provider.activeOrder, isNull);
      provider.dispose();
    },
  );
}
