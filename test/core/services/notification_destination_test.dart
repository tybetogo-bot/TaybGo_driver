import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/services/notification_destination.dart';

void main() {
  test('order updates open the referenced order', () {
    expect(
      notificationDestination({'type': 'order_update', 'order_id': 42}),
      '/order/42',
    );
    expect(
      notificationDestination({'type': 'order_update', 'orderId': 'a/b'}),
      '/order/a%2Fb',
    );
  });
  test('offers, unknown types, and missing IDs open the dispatch home', () {
    for (final data in <Map<String, dynamic>>[
      {'type': 'dispatch_offer', 'order_id': 42},
      {'type': 'new_order', 'order_id': 42},
      {'type': 'order_update', 'order_id': ' '},
      {'type': 'unknown', 'url': 'https://example.com'},
      {},
    ]) {
      expect(notificationDestination(data), '/home');
    }
  });
}
