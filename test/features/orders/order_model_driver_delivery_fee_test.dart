import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/features/orders/models/order_model.dart';

void main() {
  Map<String, dynamic> orderJson({required bool isPaid}) => {
    'id': 42,
    'order_type': 'FOOD',
    'status': 'PENDING',
    'pickup_address': {
      'full_address': 'Pickup',
      'lat': '48.20',
      'lng': '16.37',
    },
    'dropoff_address': {
      'full_address': 'Dropoff',
      'lat': '48.21',
      'lng': '16.38',
    },
    'customer_name': 'Customer',
    'total_amount': '29.90',
    'delivery_fee': '8.50',
    'driver_delivery_fee': '5.75',
    'tip': '1.25',
    'is_paid': isPaid,
  };

  test('maps driver delivery fee separately from customer totals', () {
    final order = OrderModel.fromJson(orderJson(isPaid: true));

    expect(order.driverDeliveryFee, 5.75);
    expect(order.hasDriverDeliveryFee, isTrue);
    expect(order.deliveryFee, 8.50);
    expect(order.total, 29.90);
    expect(order.formattedDriverDeliveryFee, r'$5.75');
  });

  test('keeps explicit paid and unpaid states from order details', () {
    final paid = OrderModel.fromJson(orderJson(isPaid: true));
    final unpaid = OrderModel.fromJson(orderJson(isPaid: false));

    expect(paid.isPaid, isTrue);
    expect(unpaid.isPaid, isFalse);
    expect(paid.shouldShowCustomerTotal, isFalse);
    expect(unpaid.shouldShowCustomerTotal, isTrue);
  });

  test('distinguishes a missing driver fee from an explicit zero fee', () {
    final missingFeeJson = orderJson(isPaid: true)
      ..remove('driver_delivery_fee');
    final explicitZeroJson = orderJson(isPaid: true)
      ..['driver_delivery_fee'] = '0.00';

    final missing = OrderModel.fromJson(missingFeeJson);
    final explicitZero = OrderModel.fromJson(explicitZeroJson);

    expect(missing.hasDriverDeliveryFee, isFalse);
    expect(missing.formattedDriverDeliveryFee, '—');
    expect(explicitZero.hasDriverDeliveryFee, isTrue);
    expect(explicitZero.formattedDriverDeliveryFee, r'$0.00');
  });

  test('maps shipping requirements and package details', () {
    final json = orderJson(isPaid: false)
      ..addAll({
        'order_type': 'SHIPPING',
        'requested_delivery_type': 'VAN',
        'delivery_instructions': 'Handle with care',
        'shipping_package': {
          'size': 'Medium',
          'weight_kg': '8.50',
          'content': 'Electronics',
        },
        'calculated_distance': '12.40',
        'calculated_time': 900,
        'allowed_status_options': [
          {'value': 'ON_THE_WAY', 'label': 'On the way'},
        ],
      });

    final order = OrderModel.fromJson(json);

    expect(order.orderType, OrderType.shipping);
    expect(order.requestedDeliveryType, OrderVehicleType.van);
    expect(order.shippingPackage?.size, 'Medium');
    expect(order.shippingPackage?.weightKg, 8.5);
    expect(order.shippingPackage?.content, 'Electronics');
    expect(order.deliveryInstructions, 'Handle with care');
    expect(order.nextAllowedStatus, OrderStatus.onTheWay);
    expect(order.estimatedMinutes, 15);
  });

  test('maps taxi vehicle and car class requirements', () {
    final json = orderJson(isPaid: true)
      ..addAll({
        'order_type': 'TAXI',
        'requested_vehicle_type': 'CAR',
        'requested_car_size': 'COMFORT',
      });

    final order = OrderModel.fromJson(json);

    expect(order.orderType, OrderType.taxi);
    expect(order.requestedVehicleType, OrderVehicleType.car);
    expect(order.requestedCarSize, OrderCarSize.comfort);
  });

  test(
    'preserves expired backend status instead of treating it as pending',
    () {
      final json = orderJson(isPaid: true)..['status'] = 'EXPIRED';

      expect(OrderModel.fromJson(json).status, OrderStatus.expired);
    },
  );
}
