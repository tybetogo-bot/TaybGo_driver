import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/features/earnings/models/earnings_model.dart';
import 'package:teybatdriver/features/orders/models/order_model.dart';

void main() {
  test('maps current driver earnings API field names', () {
    final response = EarningsResponse.fromJson({
      'count': 1,
      'summary': {
        'total_orders': 1,
        'total_earnings': '13.50',
        'total_driver_delivery_fees': '11.00',
        'total_tips': '2.50',
      },
      'results': [
        {
          'order_id': 91,
          'order_type': 'SHIPPING',
          'status': 'COMPLETED',
          'earned_at': '2026-08-20T10:00:00Z',
          'driver_delivery_fee': '11.00',
          'tip': '2.50',
          'earning_amount': '13.50',
        },
      ],
    });

    expect(response.summary.totalDriverDeliveryFees, 11);
    expect(response.results.single.orderType, OrderType.shipping);
    expect(response.results.single.driverDeliveryFee, 11);
    expect(response.results.single.earningAmount, 13.5);
  });

  test('retains compatibility with the previous earnings field names', () {
    final summary = EarningsSummary.fromJson({
      'total_orders': 2,
      'total_earnings': '8.00',
      'total_delivery_fees': '7.00',
      'total_tips': '1.00',
    });

    expect(summary.totalDriverDeliveryFees, 7);
  });
}
