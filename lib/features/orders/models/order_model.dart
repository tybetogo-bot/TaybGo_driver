enum OrderStatus {
  pending('PENDING', 'Pending'),
  searchingForDriver('SEARCHING_FOR_DRIVER', 'Searching for driver'),
  driverNotificationSent('DRIVER_NOTIFICATION_SENT', 'Driver notification sent'),
  accepted('ACCEPTED', 'Accepted'),
  onTheWay('ON_THE_WAY', 'On the way'),
  delivered('DELIVERED', 'Delivered'),
  completed('COMPLETED', 'Completed'),
  rejected('REJECTED', 'Rejected'),
  cancelled('CANCELLED', 'Cancelled');

  final String apiValue;
  final String displayName;

  const OrderStatus(this.apiValue, this.displayName);

  static OrderStatus fromApi(String value) {
    return OrderStatus.values.firstWhere(
      (s) => s.apiValue == value,
      orElse: () => OrderStatus.pending,
    );
  }
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
    return OrderItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['item_name'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: _parseDouble(json['price'] ?? json['unit_price']),
      notes: json['notes'] ?? json['special_instructions'],
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

  // Pricing
  final double subtotal;
  final double deliveryFee;
  final double tip;
  final double total;

  // Distance & time
  final double distance;
  final int estimatedMinutes;

  // Items (for food orders)
  final List<OrderItem> items;

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
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.tip = 0,
    this.total = 0,
    required this.distance,
    required this.estimatedMinutes,
    this.items = const [],
    DateTime? createdAt,
    this.acceptedAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Computed properties for backward compatibility
  double get price => deliveryFee > 0 ? deliveryFee : total;

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedTip => '\$${tip.toStringAsFixed(2)}';
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
  String get formattedDistance => '${distance.toStringAsFixed(1)} km';
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';
  String get formattedDeliveryFee => '\$${deliveryFee.toStringAsFixed(2)}';

  // For display in lists
  List<String> get itemNames => items.map((i) => '${i.quantity}x ${i.name}').toList();

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Parse items
    List<OrderItem> orderItems = [];
    if (json['items'] != null) {
      orderItems = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList();
    }

    // Parse restaurant info
    int? restaurantId;
    String restaurantName = '';
    if (json['restaurant'] != null) {
      final restaurant = json['restaurant'];
      restaurantId = restaurant['id'];
      restaurantName = restaurant['name'] ?? '';
    } else {
      restaurantId = json['restaurant_id'];
      restaurantName = json['restaurant_name'] ?? '';
    }

    // Parse pickup address (can be string or object)
    String pickupAddr = '';
    String pickupName = restaurantName;
    String? pickupStreet;
    String? pickupCity;
    double? pickupLat;
    double? pickupLng;

    if (json['pickup'] != null) {
      final pickup = json['pickup'];
      pickupAddr = pickup['address'] ?? pickup['full_address'] ?? '';
      pickupName = pickup['name'] ?? restaurantName;
      pickupStreet = _buildStreet(pickup['street_name'], pickup['house_number']);
      pickupCity = pickup['city'];
      pickupLat = _parseDouble(pickup['latitude'] ?? pickup['lat']);
      pickupLng = _parseDouble(pickup['longitude'] ?? pickup['lng']);
    } else if (json['pickup_address'] != null) {
      final pickupData = json['pickup_address'];
      if (pickupData is Map) {
        // New format: pickup_address is an object
        pickupAddr = pickupData['full_address'] ?? pickupData['address'] ?? '';
        pickupStreet = _buildStreet(pickupData['street_name'], pickupData['house_number']);
        pickupCity = pickupData['city'];
        pickupLat = _parseDouble(pickupData['lat'] ?? pickupData['latitude']);
        pickupLng = _parseDouble(pickupData['lng'] ?? pickupData['longitude']);
      } else {
        // Old format: pickup_address is a string
        pickupAddr = pickupData.toString();
      }
      // Use restaurant name as pickup name, or fallback
      if (pickupName.isEmpty) {
        pickupName = json['pickup_name'] ?? 'Pickup';
      }
    }

    // Fallback to restaurant coordinates if pickup not set
    if ((pickupLat == null || pickupLat == 0) && json['restaurant'] != null) {
      pickupLat = _parseDouble(json['restaurant']['lat']);
      pickupLng = _parseDouble(json['restaurant']['lng']);
    }

    // Parse dropoff address (can be string or object)
    String dropoffAddr = '';
    String? dropoffStreet;
    String? dropoffCity;
    double? dropoffLat;
    double? dropoffLng;

    if (json['dropoff'] != null) {
      final dropoff = json['dropoff'];
      dropoffAddr = dropoff['address'] ?? dropoff['full_address'] ?? '';
      dropoffStreet = _buildStreet(dropoff['street_name'], dropoff['house_number']);
      dropoffCity = dropoff['city'];
      dropoffLat = _parseDouble(dropoff['latitude'] ?? dropoff['lat']);
      dropoffLng = _parseDouble(dropoff['longitude'] ?? dropoff['lng']);
    } else if (json['dropoff_address'] != null) {
      final dropoffData = json['dropoff_address'];
      if (dropoffData is Map) {
        // New format: dropoff_address is an object
        dropoffAddr = dropoffData['full_address'] ?? dropoffData['address'] ?? '';
        dropoffStreet = _buildStreet(dropoffData['street_name'], dropoffData['house_number']);
        dropoffCity = dropoffData['city'];
        dropoffLat = _parseDouble(dropoffData['lat'] ?? dropoffData['latitude']);
        dropoffLng = _parseDouble(dropoffData['lng'] ?? dropoffData['longitude']);
      } else {
        // Old format: dropoff_address is a string
        dropoffAddr = dropoffData.toString();
      }
    } else if (json['delivery_address'] != null) {
      dropoffAddr = json['delivery_address'].toString();
    }

    // Parse customer info from driver object or customer object
    String customerName = 'Customer';
    String? customerPhone;
    if (json['customer'] != null) {
      final customer = json['customer'];
      customerName = customer['name'] ??
          '${customer['first_name'] ?? ''} ${customer['last_name'] ?? ''}'.trim();
      if (customerName.isEmpty) customerName = 'Customer';
      customerPhone = customer['phone'];
    } else {
      customerName = json['customer_name'] ?? 'Customer';
      customerPhone = json['customer_phone'];
    }

    // Parse pricing - handle both formats (with and without _amount suffix)
    final subtotal = _parseDouble(json['subtotal_amount'] ?? json['subtotal']);
    final deliveryFee = _parseDouble(json['delivery_fee'] ?? json['fee']);
    final tip = _parseDouble(json['tip']);
    final total = _parseDouble(json['total_amount'] ?? json['total']);

    // Calculate distance from coordinates if not provided
    double distance = _parseDouble(json['distance'] ?? json['distance_km']);
    if (distance == 0 && pickupLat != null && dropoffLat != null) {
      // Rough estimate: 1 degree ≈ 111km
      final latDiff = (dropoffLat - pickupLat).abs();
      final lngDiff = ((dropoffLng ?? 0) - (pickupLng ?? 0)).abs();
      distance = ((latDiff + lngDiff) * 111).roundToDouble();
      if (distance < 0.1) distance = 0.5; // Minimum distance
    }

    return OrderModel(
      id: (json['id'] ?? json['order_id'] ?? '').toString(),
      orderType: OrderType.fromApi(json['order_type'] ?? 'FOOD'),
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
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tip: tip,
      total: total,
      distance: distance,
      estimatedMinutes: _parseInt(json['estimated_minutes'] ?? json['eta_minutes'] ?? json['estimated_delivery_time']),
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
      'total': total,
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
    double? subtotal,
    double? deliveryFee,
    double? tip,
    double? total,
    double? distance,
    int? estimatedMinutes,
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
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tip: tip ?? this.tip,
      total: total ?? this.total,
      distance: distance ?? this.distance,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
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
}
