import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/features/orders/models/order_model.dart';

void main() {
  Map<String, dynamic> buildOrderJson({
    required String paymentType,
    required bool isPaid,
    String totalAmount = '25.00',
    String driverDeliveryFee = '4.50',
    String? giftCardAmountApplied,
    String? cardAmountDue,
    String? cashAmountDue,
  }) => {
    'id': 91,
    'order_type': 'FOOD',
    'status': 'DELIVERED',
    'pickup_address': {
      'full_address': 'Seller Street 1',
      'lat': '48.20',
      'lng': '16.37',
    },
    'dropoff_address': {
      'full_address': 'Customer Street 9',
      'lat': '48.21',
      'lng': '16.38',
    },
    'customer_name': 'Mira',
    'payment_type': paymentType,
    'is_paid': isPaid,
    'total_amount': totalAmount,
    'delivery_fee': '6.00',
    'driver_delivery_fee': driverDeliveryFee,
    if (giftCardAmountApplied != null)
      'gift_card_amount_applied': giftCardAmountApplied,
    if (cardAmountDue != null) 'card_amount_due': cardAmountDue,
    if (cashAmountDue != null) 'cash_amount_due': cashAmountDue,
  };

  group('OrderModel split wallet + cash payment parsing', () {
    test('handles wallet + cash split order accurately', () {
      final order = OrderModel.fromJson(
        buildOrderJson(
          paymentType: 'CASH',
          isPaid: false,
          totalAmount: '25.00',
          giftCardAmountApplied: '10.00',
          cardAmountDue: '0.00',
          cashAmountDue: '15.00',
        ),
      );

      expect(order.giftCardAmountApplied, 10.00);
      expect(order.cardAmountDue, 0.00);
      expect(order.cashAmountDue, 15.00);
      expect(order.hasGiftCardApplied, isTrue);
      expect(order.hasCashToCollect, isTrue);
      expect(order.needsCashCollection, isTrue);
      expect(order.isPaidViaWalletOnly, isFalse);
      expect(order.shouldShowCustomerTotal, isTrue);
      expect(order.formattedGiftCardApplied, '€10.00');
      expect(order.formattedCashToCollect, '€15.00');
    });

    test('handles 100% gift card wallet payment with zero cash due', () {
      final order = OrderModel.fromJson(
        buildOrderJson(
          paymentType: 'CASH',
          isPaid: true,
          totalAmount: '25.00',
          giftCardAmountApplied: '25.00',
          cardAmountDue: '0.00',
          cashAmountDue: '0.00',
        ),
      );

      expect(order.hasGiftCardApplied, isTrue);
      expect(order.hasCashToCollect, isFalse);
      expect(order.needsCashCollection, isFalse);
      expect(order.isPaidViaWalletOnly, isTrue);
      expect(order.shouldShowCustomerTotal, isTrue);
      expect(order.formattedCashToCollect, '€0.00');
    });

    test('falls back cashAmountDue to total for legacy unpaid CASH JSON', () {
      final order = OrderModel.fromJson(
        buildOrderJson(
          paymentType: 'CASH',
          isPaid: false,
          totalAmount: '18.40',
        ),
      );

      expect(order.cashAmountDue, 18.40);
      expect(order.hasCashToCollect, isTrue);
      expect(order.needsCashCollection, isTrue);
      expect(order.formattedCashToCollect, '€18.40');
    });

    test('copyWith preserves and updates split payment fields', () {
      final order = OrderModel.fromJson(
        buildOrderJson(
          paymentType: 'CASH',
          isPaid: false,
          totalAmount: '25.00',
          giftCardAmountApplied: '10.00',
          cashAmountDue: '15.00',
        ),
      );

      final updated = order.copyWith(isPaid: true, cashAmountDue: 0.0);
      expect(updated.isPaid, isTrue);
      expect(updated.cashAmountDue, 0.0);
      expect(updated.needsCashCollection, isFalse);
      expect(updated.isPaidViaWalletOnly, isTrue);
    });
  });
}
