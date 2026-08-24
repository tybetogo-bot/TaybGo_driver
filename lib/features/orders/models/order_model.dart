import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../../../core/l10n/app_localizations.dart';

enum OrderStatus {
  pending('PENDING', 'Pending'),
  searchingForDriver('SEARCHING_FOR_DRIVER', 'Searching for driver'),
  driverNotificationSent(
    'DRIVER_NOTIFICATION_SENT',
    'Driver notification sent',
  ),
  accepted('ACCEPTED', 'Accepted'),
  onTheWay('ON_THE_WAY', 'On the way'),
  delivered('DELIVERED', 'Delivered'),
  restaurantDelivered('RESTAURANT_DELIVERED', 'Restaurant delivered'),
  completed('COMPLETED', 'Completed'),
  rejected('REJECTED', 'Rejected'),
  expired('EXPIRED', 'Expired'),
  cancelled('CANCELLED', 'Cancelled');

  final String apiValue;
  final String displayName;

  const OrderStatus(this.apiValue, this.displayName);

  static OrderStatus fromApi(String value) {
    return tryFromApi(value) ?? OrderStatus.pending;
  }

  static OrderStatus? tryFromApi(String? value) {
    if (value == null || value.isEmpty) return null;
    return OrderStatus.values.cast<OrderStatus?>().firstWhere(
      (s) => s!.apiValue == value.toUpperCase(),
      orElse: () => null,
    );
  }
}

extension OrderStatusLocalization on OrderStatus {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case OrderStatus.pending:
        return l10n.pending;
      case OrderStatus.searchingForDriver:
        return l10n.searchingForDriver;
      case OrderStatus.driverNotificationSent:
        return l10n.driverNotificationSent;
      case OrderStatus.accepted:
        return l10n.accepted;
      case OrderStatus.onTheWay:
        return l10n.onTheWay;
      case OrderStatus.delivered:
        return l10n.delivered;
      case OrderStatus.restaurantDelivered:
        return l10n.restaurantDelivered;
      case OrderStatus.completed:
        return l10n.completed;
      case OrderStatus.rejected:
        return l10n.rejected;
      case OrderStatus.expired:
        return l10n.expired;
      case OrderStatus.cancelled:
        return l10n.cancelled;
    }
  }
}

enum OrderVehicleType {
  bike('BIKE'),
  motor('MOTOR'),
  car('CAR'),
  van('VAN');

  final String apiValue;

  const OrderVehicleType(this.apiValue);

  static OrderVehicleType? fromApi(dynamic value) {
    final normalized = value?.toString().toUpperCase();
    if (normalized == null || normalized.isEmpty) return null;
    return OrderVehicleType.values.cast<OrderVehicleType?>().firstWhere(
      (type) => type!.apiValue == normalized,
      orElse: () => null,
    );
  }
}

enum OrderCarSize {
  x('X'),
  comfort('COMFORT'),
  xl('XL'),
  black('BLACK');

  final String apiValue;

  const OrderCarSize(this.apiValue);

  static OrderCarSize? fromApi(dynamic value) {
    final normalized = value?.toString().toUpperCase();
    if (normalized == null || normalized.isEmpty) return null;
    return OrderCarSize.values.cast<OrderCarSize?>().firstWhere(
      (size) => size!.apiValue == normalized,
      orElse: () => null,
    );
  }
}

class ShippingPackageDetails {
  final String size;
  final double weightKg;
  final String content;

  const ShippingPackageDetails({
    required this.size,
    required this.weightKg,
    required this.content,
  });

  factory ShippingPackageDetails.fromJson(Map<String, dynamic> json) {
    return ShippingPackageDetails(
      size: json['size']?.toString() ?? '',
      weightKg: _parseDecimal(json['weight_kg'] ?? json['weight']),
      content: json['content']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'size': size,
    'weight_kg': weightKg,
    'content': content,
  };

  bool get hasDetails => size.isNotEmpty || weightKg > 0 || content.isNotEmpty;

  static double _parseDecimal(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class AllowedOrderStatusOption {
  final String value;
  final String label;

  const AllowedOrderStatusOption({required this.value, required this.label});

  factory AllowedOrderStatusOption.fromJson(Map<String, dynamic> json) {
    return AllowedOrderStatusOption(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'value': value, 'label': label};
}

enum OrderType {
  food('FOOD'),
  taxi('TAXI'),
  shipping('SHIPPING');

  final String apiValue;

  const OrderType(this.apiValue);

  static OrderType fromApi(String value) {
    return OrderType.values.firstWhere(
      (t) => t.apiValue == value,
      orElse: () => OrderType.food,
    );
  }
}

enum PaymentType {
  cash('CASH'),
  card('CARD'),
  other('OTHER');

  final String apiValue;

  const PaymentType(this.apiValue);

  static PaymentType? fromApi(String? value) {
    if (value == null || value.isEmpty) return null;
    return PaymentType.values.cast<PaymentType?>().firstWhere(
      (t) => t!.apiValue == value.toUpperCase(),
      orElse: () => null,
    );
  }
}

class OrderAddress {
  final double latitude;
  final double longitude;
  final String address;
  final String? name;

  OrderAddress({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.name,
  });

  factory OrderAddress.fromJson(Map<String, dynamic> json) {
    return OrderAddress(
      latitude: _parseDouble(json['latitude'] ?? json['lat']),
      longitude: _parseDouble(json['longitude'] ?? json['lng'] ?? json['lon']),
      address: json['address'] ?? json['formatted_address'] ?? '',
      name: json['name'] ?? json['place_name'],
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class OrderItem {
  final int id;
  final String name;
  final int quantity;
  final double price;
  final String? notes;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    debugPrint('[OrderItem] Parsing: $json');

    // Parse ID
    final id = json['id'] ?? json['item_id'] ?? json['order_item_id'] ?? 0;

    // Parse name - API uses 'item_name' directly
    String name =
        (json['item_name'] ?? json['name'] ?? json['product_name'] ?? '')
            .toString();

    // Check nested menu_item or item object as fallback
    if (name.isEmpty && json['menu_item'] != null && json['menu_item'] is Map) {
      name = json['menu_item']['name']?.toString() ?? '';
    }
    if (name.isEmpty && json['item'] != null && json['item'] is Map) {
      name = json['item']['name']?.toString() ?? '';
    }

    // Parse quantity
    final quantity = _parseInt(
      json['quantity'] ?? json['qty'] ?? json['count'] ?? 1,
    );

    // Parse price
    double price = _parseDouble(
      json['item_price'] ?? json['price'] ?? json['unit_price'] ?? 0,
    );

    // Parse notes/customizations - API uses 'customizations' field
    final notes =
        json['customizations'] ?? json['notes'] ?? json['special_instructions'];

    debugPrint('[OrderItem] Parsed: name="$name", qty=$quantity, notes=$notes');

    return OrderItem(
      id: id is int ? id : int.tryParse(id.toString()) ?? 0,
      name: name,
      quantity: quantity,
      price: price,
      notes: notes?.toString(),
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
    if (value == null) return 1;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 1;
    return 1;
  }
}

class OrderModel {
  final String id;
  final OrderType orderType;
  final OrderStatus status;

  // Pickup info
  final String pickupAddress;
  final String pickupName;
  final String? pickupStreet;
  final String? pickupCity;
  final double? pickupLat;
  final double? pickupLng;

  // Dropoff info
  final String dropoffAddress;
  final String? dropoffStreet;
  final String? dropoffCity;
  final double? dropoffLat;
  final double? dropoffLng;

  // Customer info
  final String customerName;
  final String? customerPhone;

  // Restaurant info (for food orders)
  final int? restaurantId;
  final String? restaurantName;

  // Type-specific requirements
  final String? deliveryInstructions;
  final OrderVehicleType? requestedVehicleType;
  final OrderVehicleType? requestedDeliveryType;
  final OrderCarSize? requestedCarSize;
  final ShippingPackageDetails? shippingPackage;
  final List<AllowedOrderStatusOption> allowedStatusOptions;

  // Pricing
  final double subtotal;
  final double deliveryFee;
  final double driverDeliveryFee;
  final bool hasDriverDeliveryFee;
  final double tip;
  final double total;

  // Distance & time
  final double distance;
  final int estimatedMinutes;

  // Items (for food orders)
  final List<OrderItem> items;

  // Payment
  final PaymentType? paymentType;
  final bool? isPaid;

  // Timestamps
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  OrderModel({
    required this.id,
    this.orderType = OrderType.food,
    this.status = OrderStatus.pending,
    required this.pickupAddress,
    required this.pickupName,
    this.pickupStreet,
    this.pickupCity,
    this.pickupLat,
    this.pickupLng,
    required this.dropoffAddress,
    this.dropoffStreet,
    this.dropoffCity,
    this.dropoffLat,
    this.dropoffLng,
    required this.customerName,
    this.customerPhone,
    this.restaurantId,
    this.restaurantName,
    this.deliveryInstructions,
    this.requestedVehicleType,
    this.requestedDeliveryType,
    this.requestedCarSize,
    this.shippingPackage,
    this.allowedStatusOptions = const [],
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.driverDeliveryFee = 0,
    bool? hasDriverDeliveryFee,
    this.tip = 0,
    this.total = 0,
    required this.distance,
    required this.estimatedMinutes,
    this.paymentType,
    this.isPaid,
    this.items = const [],
    DateTime? createdAt,
    this.acceptedAt,
    this.completedAt,
  }) : hasDriverDeliveryFee = hasDriverDeliveryFee ?? driverDeliveryFee != 0,
       createdAt = createdAt ?? DateTime.now();

  /// Whether we have a confirmed paid/unpaid value we can safely show.
  bool get hasPaymentInfo => isPaid != null;

  /// Whether the driver needs to collect cash from the customer
  bool get needsCashCollection =>
      paymentType == PaymentType.cash && isPaid == false;

  // Computed properties for backward compatibility
  double get price => deliveryFee > 0 ? deliveryFee : total;

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedTip => '\$${tip.toStringAsFixed(2)}';
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
  String get formattedDistance => '${distance.toStringAsFixed(1)} km';
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';
  String get formattedDeliveryFee => '\$${deliveryFee.toStringAsFixed(2)}';
  String get formattedDriverDeliveryFee =>
      hasDriverDeliveryFee ? '\$${driverDeliveryFee.toStringAsFixed(2)}' : '—';
  bool get shouldShowCustomerTotal => isPaid == false;
  bool get hasDeliveryInstructions =>
      deliveryInstructions != null && deliveryInstructions!.trim().isNotEmpty;

  OrderStatus? get nextAllowedStatus {
    for (final option in allowedStatusOptions) {
      final status = OrderStatus.tryFromApi(option.value);
      if (status != null) return status;
    }
    return null;
  }

  // For display in lists
  List<String> get itemNames =>
      items.map((i) => '${i.quantity}x ${i.name}').toList();

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final orderId = (json['id'] ?? json['order_id'] ?? '').toString();
    final orderType = OrderType.fromApi(
      json['order_type']?.toString() ?? 'FOOD',
    );
    debugPrint(
      '[OrderModel] ═══════════════════════════════════════════════════',
    );
    debugPrint('[OrderModel] PARSING ORDER: $orderId');
    debugPrint('[OrderModel] Raw JSON keys: ${json.keys.toList()}');

    // Parse items - check multiple possible field names
    debugPrint('[OrderModel] --- ITEMS PARSING ---');
    debugPrint('[OrderModel] items field: ${json['items']}');
    debugPrint('[OrderModel] order_items field: ${json['order_items']}');
    debugPrint('[OrderModel] line_items field: ${json['line_items']}');
    debugPrint('[OrderModel] products field: ${json['products']}');

    List<OrderItem> orderItems = [];
    List<dynamic>? itemsList;
    String itemsSource = '';

    // Try different field names for items array
    if (json['items'] != null &&
        json['items'] is List &&
        (json['items'] as List).isNotEmpty) {
      itemsList = json['items'] as List;
      itemsSource = 'items';
    } else if (json['order_items'] != null &&
        json['order_items'] is List &&
        (json['order_items'] as List).isNotEmpty) {
      itemsList = json['order_items'] as List;
      itemsSource = 'order_items';
    } else if (json['line_items'] != null &&
        json['line_items'] is List &&
        (json['line_items'] as List).isNotEmpty) {
      itemsList = json['line_items'] as List;
      itemsSource = 'line_items';
    } else if (json['products'] != null &&
        json['products'] is List &&
        (json['products'] as List).isNotEmpty) {
      itemsList = json['products'] as List;
      itemsSource = 'products';
    }

    if (itemsList != null) {
      debugPrint(
        '[OrderModel] Found items in "$itemsSource" field, count: ${itemsList.length}',
      );
      for (int i = 0; i < itemsList.length; i++) {
        final item = itemsList[i];
        debugPrint('[OrderModel] *** RAW ITEM $i FULL JSON: $item');
        if (item is Map<String, dynamic>) {
          orderItems.add(OrderItem.fromJson(item));
        } else {
          debugPrint(
            '[OrderModel] WARNING: Item $i is not a Map: ${item.runtimeType}',
          );
        }
      }
      debugPrint(
        '[OrderModel] Parsed ${orderItems.length} items from "$itemsSource"',
      );
    } else {
      debugPrint(
        '[OrderModel] WARNING: No items found in JSON! Available keys: ${json.keys.toList()}',
      );
    }

    // Parse restaurant info
    int? restaurantId;
    String restaurantName = '';
    if (json['restaurant'] != null) {
      final restaurant = json['restaurant'];
      restaurantId = restaurant['id'];
      restaurantName = restaurant['name'] ?? '';
      debugPrint(
        '[OrderModel] Restaurant (from object): id=$restaurantId, name=$restaurantName',
      );
      debugPrint(
        '[OrderModel] Restaurant coords: lat=${restaurant['lat']}, lng=${restaurant['lng']}',
      );
    } else {
      restaurantId = json['restaurant_id'];
      restaurantName = json['restaurant_name'] ?? '';
      debugPrint(
        '[OrderModel] Restaurant (from fields): id=$restaurantId, name=$restaurantName',
      );
    }

    // Parse pickup address (can be string or object)
    String pickupAddr = '';
    String pickupName = restaurantName;
    String? pickupStreet;
    String? pickupCity;
    double? pickupLat;
    double? pickupLng;

    debugPrint('[OrderModel] --- PICKUP PARSING ---');
    debugPrint('[OrderModel] pickup field: ${json['pickup']}');
    debugPrint('[OrderModel] pickup_address field: ${json['pickup_address']}');

    if (json['pickup'] != null) {
      final pickup = json['pickup'];
      pickupAddr = pickup['address'] ?? pickup['full_address'] ?? '';
      pickupName = pickup['name'] ?? restaurantName;
      pickupStreet = _buildStreet(
        pickup['street_name'],
        pickup['house_number'],
      );
      pickupCity = pickup['city'];
      pickupLat = _parseDouble(pickup['latitude'] ?? pickup['lat']);
      pickupLng = _parseDouble(pickup['longitude'] ?? pickup['lng']);
      debugPrint('[OrderModel] Pickup from "pickup" object:');
      debugPrint('[OrderModel]   name: $pickupName');
      debugPrint('[OrderModel]   street: $pickupStreet');
      debugPrint('[OrderModel]   city: $pickupCity');
      debugPrint('[OrderModel]   address: $pickupAddr');
      debugPrint('[OrderModel]   coords: lat=$pickupLat, lng=$pickupLng');
    } else if (json['pickup_address'] != null) {
      final pickupData = json['pickup_address'];
      if (pickupData is Map) {
        // New format: pickup_address is an object
        pickupAddr = pickupData['full_address'] ?? pickupData['address'] ?? '';
        pickupStreet = _buildStreet(
          pickupData['street_name'],
          pickupData['house_number'],
        );
        pickupCity = pickupData['city'];
        pickupLat = _parseDouble(pickupData['lat'] ?? pickupData['latitude']);
        pickupLng = _parseDouble(pickupData['lng'] ?? pickupData['longitude']);
        debugPrint('[OrderModel] Pickup from "pickup_address" object:');
        debugPrint('[OrderModel]   street: $pickupStreet');
        debugPrint('[OrderModel]   city: $pickupCity');
        debugPrint('[OrderModel]   address: $pickupAddr');
        debugPrint('[OrderModel]   coords: lat=$pickupLat, lng=$pickupLng');
      } else {
        // Old format: pickup_address is a string
        pickupAddr = pickupData.toString();
        debugPrint(
          '[OrderModel] Pickup from "pickup_address" string: $pickupAddr',
        );
      }
      // Use restaurant name as pickup name, or fallback
      if (pickupName.isEmpty) {
        pickupName = json['pickup_name'] ?? 'Pickup';
      }
    } else {
      debugPrint('[OrderModel] WARNING: No pickup data found in JSON!');
    }

    // Fallback to restaurant coordinates if pickup not set
    if ((pickupLat == null || pickupLat == 0) && json['restaurant'] != null) {
      pickupLat = _parseDouble(json['restaurant']['lat']);
      pickupLng = _parseDouble(json['restaurant']['lng']);
      debugPrint(
        '[OrderModel] Using restaurant coords as pickup fallback: lat=$pickupLat, lng=$pickupLng',
      );
    }

    // Parse dropoff address (can be string or object)
    String dropoffAddr = '';
    String? dropoffStreet;
    String? dropoffCity;
    double? dropoffLat;
    double? dropoffLng;
    String? dropoffCustomerName;

    debugPrint('[OrderModel] --- DROPOFF PARSING ---');
    debugPrint('[OrderModel] dropoff field: ${json['dropoff']}');
    debugPrint(
      '[OrderModel] dropoff_address field: ${json['dropoff_address']}',
    );
    debugPrint(
      '[OrderModel] delivery_address field: ${json['delivery_address']}',
    );

    if (json['dropoff'] != null) {
      final dropoff = json['dropoff'];
      dropoffAddr = dropoff['address'] ?? dropoff['full_address'] ?? '';
      dropoffStreet = _buildStreet(
        dropoff['street_name'],
        dropoff['house_number'],
      );
      dropoffCity = dropoff['city'];
      dropoffLat = _parseDouble(dropoff['latitude'] ?? dropoff['lat']);
      dropoffLng = _parseDouble(dropoff['longitude'] ?? dropoff['lng']);
      debugPrint('[OrderModel] Dropoff from "dropoff" object:');
      debugPrint('[OrderModel]   street: $dropoffStreet');
      debugPrint('[OrderModel]   city: $dropoffCity');
      debugPrint('[OrderModel]   address: $dropoffAddr');
      debugPrint('[OrderModel]   coords: lat=$dropoffLat, lng=$dropoffLng');
    } else if (json['dropoff_address'] != null) {
      final dropoffData = json['dropoff_address'];
      if (dropoffData is Map) {
        // New format: dropoff_address is an object
        dropoffAddr =
            dropoffData['full_address'] ?? dropoffData['address'] ?? '';
        dropoffStreet = _buildStreet(
          dropoffData['street_name'],
          dropoffData['house_number'],
        );
        dropoffCity = dropoffData['city'];
        dropoffLat = _parseDouble(
          dropoffData['lat'] ?? dropoffData['latitude'],
        );
        dropoffLng = _parseDouble(
          dropoffData['lng'] ?? dropoffData['longitude'],
        );
        // Extract customer name from label field (format: "Customer: Name")
        if (dropoffData['label'] != null) {
          final label = dropoffData['label'].toString();
          if (label.contains(':')) {
            dropoffCustomerName = label.split(':').last.trim();
          } else {
            dropoffCustomerName = label;
          }
          debugPrint(
            '[OrderModel]   customer from label: $dropoffCustomerName',
          );
        }
        debugPrint('[OrderModel] Dropoff from "dropoff_address" object:');
        debugPrint('[OrderModel]   street: $dropoffStreet');
        debugPrint('[OrderModel]   city: $dropoffCity');
        debugPrint('[OrderModel]   address: $dropoffAddr');
        debugPrint('[OrderModel]   coords: lat=$dropoffLat, lng=$dropoffLng');
      } else {
        // Old format: dropoff_address is a string
        dropoffAddr = dropoffData.toString();
        debugPrint(
          '[OrderModel] Dropoff from "dropoff_address" string: $dropoffAddr',
        );
      }
    } else if (json['delivery_address'] != null) {
      dropoffAddr = json['delivery_address'].toString();
      debugPrint('[OrderModel] Dropoff from "delivery_address": $dropoffAddr');
    } else {
      debugPrint('[OrderModel] WARNING: No dropoff data found in JSON!');
    }

    // Parse customer info from driver object or customer object
    String customerName = 'Customer';
    String? customerPhone;
    debugPrint('[OrderModel] --- CUSTOMER PARSING ---');
    debugPrint('[OrderModel] Raw customer fields:');
    debugPrint('[OrderModel]   customer: ${json['customer']}');
    debugPrint('[OrderModel]   customer_name: ${json['customer_name']}');
    debugPrint('[OrderModel]   customer_phone: ${json['customer_phone']}');
    debugPrint('[OrderModel]   recipient: ${json['recipient']}');
    debugPrint('[OrderModel]   recipient_name: ${json['recipient_name']}');
    debugPrint('[OrderModel]   user: ${json['user']}');
    debugPrint('[OrderModel]   buyer: ${json['buyer']}');
    debugPrint(
      '[OrderModel]   delivery_address label: ${json['delivery_address'] is Map ? json['delivery_address']['label'] : 'N/A'}',
    );
    debugPrint(
      '[OrderModel]   dropoff_address label: ${json['dropoff_address'] is Map ? json['dropoff_address']['label'] : 'N/A'}',
    );

    if (json['customer'] != null && json['customer'] is Map) {
      final customer = json['customer'];
      customerName =
          customer['name'] ??
          customer['full_name'] ??
          '${customer['first_name'] ?? ''} ${customer['last_name'] ?? ''}'
              .trim();
      if (customerName.isEmpty) customerName = 'Customer';
      customerPhone =
          customer['phone'] ?? customer['phone_number'] ?? customer['mobile'];
      debugPrint(
        '[OrderModel] Customer from "customer" object: name=$customerName, phone=$customerPhone',
      );
    } else if (json['recipient'] != null && json['recipient'] is Map) {
      final recipient = json['recipient'];
      customerName =
          recipient['name'] ??
          recipient['full_name'] ??
          '${recipient['first_name'] ?? ''} ${recipient['last_name'] ?? ''}'
              .trim();
      if (customerName.isEmpty) customerName = 'Customer';
      customerPhone =
          recipient['phone'] ??
          recipient['phone_number'] ??
          recipient['mobile'];
      debugPrint(
        '[OrderModel] Customer from "recipient" object: name=$customerName, phone=$customerPhone',
      );
    } else if (json['user'] != null && json['user'] is Map) {
      final user = json['user'];
      customerName =
          user['name'] ??
          user['full_name'] ??
          '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
      if (customerName.isEmpty) customerName = 'Customer';
      customerPhone = user['phone'] ?? user['phone_number'] ?? user['mobile'];
      debugPrint(
        '[OrderModel] Customer from "user" object: name=$customerName, phone=$customerPhone',
      );
    } else {
      // Try direct field names
      customerName =
          json['customer_name'] ??
          json['recipient_name'] ??
          json['buyer_name'] ??
          'Customer';
      customerPhone =
          json['customer_phone'] ??
          json['customer_phone_number'] ??
          json['recipient_phone'] ??
          json['buyer_phone'];
      debugPrint(
        '[OrderModel] Customer from direct fields: name=$customerName, phone=$customerPhone',
      );
    }

    // Use dropoff label customer name if no customer info found
    if (customerName == 'Customer' &&
        dropoffCustomerName != null &&
        dropoffCustomerName.isNotEmpty) {
      customerName = dropoffCustomerName;
      debugPrint('[OrderModel] Customer from dropoff label: $customerName');
    }

    // Fallback: try top-level phone fields if still missing
    if (customerPhone == null || customerPhone.isEmpty) {
      customerPhone =
          (json['customer_phone_number'] ??
                  json['customer_phone'] ??
                  json['phone_number'] ??
                  json['phone'])
              ?.toString();
      if (customerPhone != null && customerPhone.isNotEmpty) {
        debugPrint('[OrderModel] Phone from top-level field: $customerPhone');
      }
    }

    // Fallback: try to extract phone from address objects if still missing
    if (customerPhone == null || customerPhone.isEmpty) {
      final addressSources = [
        json['dropoff'],
        json['dropoff_address'],
        json['delivery_address'],
        json['pickup'],
        json['pickup_address'],
      ];
      for (final src in addressSources) {
        if (src is Map) {
          final phone =
              src['phone'] ??
              src['phone_number'] ??
              src['mobile'] ??
              src['contact_phone'];
          if (phone != null && phone.toString().isNotEmpty) {
            customerPhone = phone.toString();
            debugPrint(
              '[OrderModel] Phone from address object: $customerPhone',
            );
            break;
          }
        }
      }
    }

    debugPrint(
      '[OrderModel] Final customer: name=$customerName, phone=$customerPhone',
    );

    // Parse pricing - handle both formats (with and without _amount suffix)
    debugPrint('[OrderModel] --- PRICING ---');
    debugPrint('[OrderModel] Raw pricing fields:');
    debugPrint('[OrderModel]   subtotal_amount: ${json['subtotal_amount']}');
    debugPrint('[OrderModel]   subtotal: ${json['subtotal']}');
    debugPrint('[OrderModel]   delivery_fee: ${json['delivery_fee']}');
    debugPrint(
      '[OrderModel]   driver_delivery_fee: ${json['driver_delivery_fee']}',
    );
    debugPrint('[OrderModel]   fee: ${json['fee']}');
    debugPrint('[OrderModel]   tip: ${json['tip']}');
    debugPrint('[OrderModel]   tip_amount: ${json['tip_amount']}');
    debugPrint('[OrderModel]   driver_tip: ${json['driver_tip']}');
    debugPrint('[OrderModel]   total_amount: ${json['total_amount']}');
    debugPrint('[OrderModel]   total: ${json['total']}');

    final subtotal = _parseDouble(json['subtotal_amount'] ?? json['subtotal']);
    final deliveryFee = _parseDouble(json['delivery_fee'] ?? json['fee']);
    final rawDriverDeliveryFee = json['driver_delivery_fee'];
    final hasDriverDeliveryFee =
        json.containsKey('driver_delivery_fee') &&
        rawDriverDeliveryFee != null &&
        rawDriverDeliveryFee.toString().trim().isNotEmpty;
    final driverDeliveryFee = hasDriverDeliveryFee
        ? _parseDouble(rawDriverDeliveryFee)
        : 0.0;
    final tip = _parseDouble(
      json['tip_amount'] ?? json['tip'] ?? json['driver_tip'],
    );
    final total = _parseDouble(json['total_amount'] ?? json['total']);
    debugPrint(
      '[OrderModel] Parsed pricing: subtotal=$subtotal, '
      'deliveryFee=$deliveryFee, driverDeliveryFee=$driverDeliveryFee, '
      'tip=$tip, total=$total',
    );

    // Parse distance and time from API
    debugPrint('[OrderModel] --- DISTANCE & TIME ---');
    debugPrint('[OrderModel] distance field: ${json['distance']}');
    debugPrint('[OrderModel] distance_km field: ${json['distance_km']}');
    debugPrint(
      '[OrderModel] estimated_minutes field: ${json['estimated_minutes']}',
    );
    debugPrint('[OrderModel] eta_minutes field: ${json['eta_minutes']}');
    debugPrint(
      '[OrderModel] estimated_delivery_time field: ${json['estimated_delivery_time']}',
    );

    // Calculate distance - use API value or calculate using Haversine formula
    double distance = _parseDouble(
      json['distance'] ?? json['calculated_distance'] ?? json['distance_km'],
    );
    if (distance == 0 &&
        pickupLat != null &&
        pickupLat != 0 &&
        dropoffLat != null &&
        dropoffLat != 0 &&
        pickupLng != null &&
        pickupLng != 0 &&
        dropoffLng != null &&
        dropoffLng != 0) {
      // Use Haversine formula for accurate distance calculation
      distance = _calculateHaversineDistance(
        pickupLat,
        pickupLng,
        dropoffLat,
        dropoffLng,
      );
      debugPrint(
        '[OrderModel] Distance calculated via Haversine: ${distance.toStringAsFixed(2)} km',
      );
      if (distance < 0.1) distance = 0.5; // Minimum distance
    } else if (distance > 0) {
      debugPrint('[OrderModel] Distance from API: $distance km');
    } else {
      debugPrint(
        '[OrderModel] WARNING: Could not determine distance! Coords: pickup($pickupLat, $pickupLng) dropoff($dropoffLat, $dropoffLng)',
      );
      distance = 0;
    }

    // Parse estimated time - use API value or calculate from distance
    int estimatedMinutes = _parseInt(
      json['estimated_minutes'] ??
          json['eta_minutes'] ??
          json['estimated_delivery_time'],
    );
    if (estimatedMinutes == 0) {
      final calculatedSeconds = _parseInt(json['calculated_time']);
      if (calculatedSeconds > 0) {
        estimatedMinutes = (calculatedSeconds / 60).ceil();
      }
    }
    if (estimatedMinutes == 0 && distance > 0) {
      // Estimate based on average delivery speed of 25 km/h in city traffic
      // Plus 5 minutes for pickup
      estimatedMinutes = ((distance / 25) * 60 + 5).round();
      if (estimatedMinutes < 5) estimatedMinutes = 5; // Minimum 5 minutes
      debugPrint(
        '[OrderModel] Estimated time calculated: $estimatedMinutes min (from ${distance.toStringAsFixed(1)} km @ 25km/h + 5min pickup)',
      );
    } else if (estimatedMinutes > 0) {
      debugPrint('[OrderModel] Estimated time from API: $estimatedMinutes min');
    } else {
      debugPrint('[OrderModel] WARNING: Could not determine estimated time!');
    }

    debugPrint(
      '[OrderModel] ═══════════════════════════════════════════════════',
    );
    debugPrint('[OrderModel] FINAL VALUES for order $orderId:');
    debugPrint(
      '[OrderModel]   Pickup: $pickupName | $pickupStreet | $pickupCity | ($pickupLat, $pickupLng)',
    );
    debugPrint(
      '[OrderModel]   Dropoff: $customerName | $dropoffStreet | $dropoffCity | ($dropoffLat, $dropoffLng)',
    );
    debugPrint(
      '[OrderModel]   Distance: ${distance.toStringAsFixed(1)} km | Time: $estimatedMinutes min',
    );
    debugPrint(
      '[OrderModel] ═══════════════════════════════════════════════════',
    );

    // Parse payment type and status
    final paymentType = PaymentType.fromApi(json['payment_type']?.toString());
    final bool? isPaid = json['is_paid'] != null
        ? (json['is_paid'] == true ||
              json['is_paid'] == 1 ||
              json['is_paid'] == '1' ||
              json['is_paid'] == 'true')
        : null;

    final requestedVehicleType = OrderVehicleType.fromApi(
      json['requested_vehicle_type'],
    );
    final requestedDeliveryType = OrderVehicleType.fromApi(
      json['requested_delivery_type'] ??
          (orderType == OrderType.shipping
              ? json['requested_vehicle_type']
              : null),
    );
    final requestedCarSize = OrderCarSize.fromApi(json['requested_car_size']);
    final packageJson = json['shipping_package'] ?? json['package'];
    final shippingPackage = packageJson is Map
        ? ShippingPackageDetails.fromJson(
            Map<String, dynamic>.from(packageJson),
          )
        : null;
    final allowedStatusOptions =
        (json['allowed_status_options'] as List?)
            ?.whereType<Map>()
            .map(
              (option) => AllowedOrderStatusOption.fromJson(
                Map<String, dynamic>.from(option),
              ),
            )
            .toList() ??
        const <AllowedOrderStatusOption>[];

    return OrderModel(
      id: orderId,
      orderType: orderType,
      status: OrderStatus.fromApi(json['status'] ?? 'PENDING'),
      pickupAddress: pickupAddr,
      pickupName: pickupName.isNotEmpty ? pickupName : 'Pickup',
      pickupStreet: pickupStreet,
      pickupCity: pickupCity,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffAddress: dropoffAddr,
      dropoffStreet: dropoffStreet,
      dropoffCity: dropoffCity,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
      customerName: customerName,
      customerPhone: customerPhone,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      deliveryInstructions: json['delivery_instructions']?.toString(),
      requestedVehicleType: requestedVehicleType,
      requestedDeliveryType: requestedDeliveryType,
      requestedCarSize: requestedCarSize,
      shippingPackage: shippingPackage,
      allowedStatusOptions: allowedStatusOptions,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      driverDeliveryFee: driverDeliveryFee,
      hasDriverDeliveryFee: hasDriverDeliveryFee,
      tip: tip,
      total: total,
      distance: distance,
      estimatedMinutes: estimatedMinutes,
      paymentType: paymentType,
      isPaid: isPaid,
      items: orderItems,
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      acceptedAt: _parseDateTime(json['accepted_at']),
      completedAt: _parseDateTime(json['completed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_type': orderType.apiValue,
      'status': status.apiValue,
      'pickup_address': pickupAddress,
      'pickup_name': pickupName,
      'dropoff_address': dropoffAddress,
      'customer_name': customerName,
      'delivery_instructions': deliveryInstructions,
      'requested_vehicle_type': requestedVehicleType?.apiValue,
      'requested_delivery_type': requestedDeliveryType?.apiValue,
      'requested_car_size': requestedCarSize?.apiValue,
      'shipping_package': shippingPackage?.toJson(),
      'allowed_status_options': allowedStatusOptions
          .map((option) => option.toJson())
          .toList(),
      'total': total,
      if (hasDriverDeliveryFee) 'driver_delivery_fee': driverDeliveryFee,
      'payment_type': paymentType?.apiValue,
      'is_paid': isPaid,
      'distance': distance,
      'estimated_minutes': estimatedMinutes,
    };
  }

  OrderModel copyWith({
    String? id,
    OrderType? orderType,
    OrderStatus? status,
    String? pickupAddress,
    String? pickupName,
    String? pickupStreet,
    String? pickupCity,
    double? pickupLat,
    double? pickupLng,
    String? dropoffAddress,
    String? dropoffStreet,
    String? dropoffCity,
    double? dropoffLat,
    double? dropoffLng,
    String? customerName,
    String? customerPhone,
    int? restaurantId,
    String? restaurantName,
    String? deliveryInstructions,
    OrderVehicleType? requestedVehicleType,
    OrderVehicleType? requestedDeliveryType,
    OrderCarSize? requestedCarSize,
    ShippingPackageDetails? shippingPackage,
    List<AllowedOrderStatusOption>? allowedStatusOptions,
    double? subtotal,
    double? deliveryFee,
    double? driverDeliveryFee,
    bool? hasDriverDeliveryFee,
    double? tip,
    double? total,
    double? distance,
    int? estimatedMinutes,
    PaymentType? paymentType,
    bool? isPaid,
    List<OrderItem>? items,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderType: orderType ?? this.orderType,
      status: status ?? this.status,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      pickupName: pickupName ?? this.pickupName,
      pickupStreet: pickupStreet ?? this.pickupStreet,
      pickupCity: pickupCity ?? this.pickupCity,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      dropoffStreet: dropoffStreet ?? this.dropoffStreet,
      dropoffCity: dropoffCity ?? this.dropoffCity,
      dropoffLat: dropoffLat ?? this.dropoffLat,
      dropoffLng: dropoffLng ?? this.dropoffLng,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      requestedVehicleType: requestedVehicleType ?? this.requestedVehicleType,
      requestedDeliveryType:
          requestedDeliveryType ?? this.requestedDeliveryType,
      requestedCarSize: requestedCarSize ?? this.requestedCarSize,
      shippingPackage: shippingPackage ?? this.shippingPackage,
      allowedStatusOptions: allowedStatusOptions ?? this.allowedStatusOptions,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      driverDeliveryFee: driverDeliveryFee ?? this.driverDeliveryFee,
      hasDriverDeliveryFee:
          hasDriverDeliveryFee ??
          (driverDeliveryFee != null ? true : this.hasDriverDeliveryFee),
      tip: tip ?? this.tip,
      total: total ?? this.total,
      distance: distance ?? this.distance,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      paymentType: paymentType ?? this.paymentType,
      isPaid: isPaid ?? this.isPaid,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
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

  static String? _buildStreet(dynamic streetName, dynamic houseNumber) {
    if (streetName == null) return null;
    final street = streetName.toString();
    if (houseNumber != null && houseNumber.toString().isNotEmpty) {
      return '$street ${houseNumber.toString()}';
    }
    return street;
  }

  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in kilometers
  static double _calculateHaversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;

    // Convert degrees to radians
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double lat1Rad = _degreesToRadians(lat1);
    final double lat2Rad = _degreesToRadians(lat2);

    // Haversine formula
    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
