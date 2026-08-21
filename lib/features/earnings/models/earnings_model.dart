import '../../orders/models/order_model.dart';

class EarningsSummary {
  final int totalOrders;
  final double totalEarnings;
  final double totalDriverDeliveryFees;
  final double totalTips;

  EarningsSummary({
    required this.totalOrders,
    required this.totalEarnings,
    required this.totalDriverDeliveryFees,
    required this.totalTips,
  });

  factory EarningsSummary.fromJson(Map<String, dynamic> json) {
    return EarningsSummary(
      totalOrders: _parseInt(json['total_orders']),
      totalEarnings: _parseDouble(json['total_earnings']),
      totalDriverDeliveryFees: _parseDouble(
        json['total_driver_delivery_fees'] ?? json['total_delivery_fees'],
      ),
      totalTips: _parseDouble(json['total_tips']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class EarningEntry {
  final int orderId;
  final OrderType orderType;
  final PaymentType? paymentType;
  final OrderStatus status;
  final String? restaurantName;
  final DateTime? earnedAt;
  final double driverDeliveryFee;
  final double tip;
  final double earningAmount;

  EarningEntry({
    required this.orderId,
    required this.orderType,
    this.paymentType,
    required this.status,
    this.restaurantName,
    this.earnedAt,
    required this.driverDeliveryFee,
    required this.tip,
    required this.earningAmount,
  });

  factory EarningEntry.fromJson(Map<String, dynamic> json) {
    return EarningEntry(
      orderId: _parseInt(json['order_id']),
      orderType: OrderType.fromApi(json['order_type'] ?? 'FOOD'),
      paymentType: PaymentType.fromApi(json['payment_type']),
      status: OrderStatus.fromApi(json['status'] ?? 'PENDING'),
      restaurantName: json['restaurant_name'],
      earnedAt: _parseDateTime(json['earned_at']),
      driverDeliveryFee: _parseDouble(
        json['driver_delivery_fee'] ?? json['delivery_fee'],
      ),
      tip: _parseDouble(json['tip']),
      earningAmount: _parseDouble(json['earning_amount']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toLocal();
    if (value is String) return DateTime.tryParse(value)?.toLocal();
    return null;
  }
}

class EarningsResponse {
  final int count;
  final String? next;
  final String? previous;
  final EarningsSummary summary;
  final List<EarningEntry> results;

  EarningsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.summary,
    required this.results,
  });

  factory EarningsResponse.fromJson(Map<String, dynamic> json) {
    return EarningsResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      summary: EarningsSummary.fromJson(json['summary'] ?? {}),
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => EarningEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
