class DriverProfile {
  final int id;
  final String? firstName;
  final String? lastName;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final double rating;
  final int totalOrders;
  final double totalEarnings;
  final bool isOnline;
  final bool isVerified;
  final String? vehicleType;
  final String? vehiclePlate;
  final DateTime? createdAt;

  DriverProfile({
    required this.id,
    this.firstName,
    this.lastName,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.rating = 0.0,
    this.totalOrders = 0,
    this.totalEarnings = 0.0,
    this.isOnline = false,
    this.isVerified = false,
    this.vehicleType,
    this.vehiclePlate,
    this.createdAt,
  });

  String get fullName {
    if (firstName == null && lastName == null) return 'Driver';
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  String get formattedRating => rating.toStringAsFixed(1);

  String get formattedEarnings {
    if (totalEarnings >= 1000) {
      return '\$${(totalEarnings / 1000).toStringAsFixed(1)}K';
    }
    return '\$${totalEarnings.toStringAsFixed(2)}';
  }

  String get memberSince {
    if (createdAt == null) return 'N/A';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[createdAt!.month - 1]} ${createdAt!.year.toString().substring(2)}';
  }

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    // Handle nested user object if present
    final user = json['user'] as Map<String, dynamic>? ?? json;

    // Parse name: try first_name/last_name, then fall back to single 'name' field
    String? firstName = user['first_name'] ?? json['first_name'];
    String? lastName = user['last_name'] ?? json['last_name'];
    if (firstName == null && lastName == null) {
      final fullName = (user['name'] ?? json['name'] ?? json['full_name'] ?? user['full_name']) as String?;
      if (fullName != null && fullName.trim().isNotEmpty) {
        final parts = fullName.trim().split(RegExp(r'\s+'));
        firstName = parts.first;
        lastName = parts.length > 1 ? parts.sublist(1).join(' ') : null;
      }
    }

    return DriverProfile(
      id: json['id'] ?? user['id'] ?? 0,
      firstName: firstName,
      lastName: lastName,
      phone: user['phone'] ?? json['phone'] ?? '',
      email: user['email'] ?? json['email'],
      avatarUrl: json['avatar'] ?? json['avatar_url'] ?? user['avatar'],
      rating: _parseDouble(json['rating'] ?? json['average_rating']),
      totalOrders: _parseInt(json['total_orders'] ?? json['orders_count']),
      totalEarnings: _parseDouble(json['total_earnings'] ?? json['earnings']),
      isOnline: json['is_online'] ?? false,
      isVerified: json['is_verified'] ?? json['verified'] ?? json['status'] == 'APPROVED',
      vehicleType: json['vehicle_type'],
      vehiclePlate: json['vehicle_plate'] ?? json['license_plate'],
      createdAt: _parseDateTime(json['created_at'] ?? user['date_joined']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'vehicle_type': vehicleType,
      'vehicle_plate': vehiclePlate,
    };
  }

  DriverProfile copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? avatarUrl,
    double? rating,
    int? totalOrders,
    double? totalEarnings,
    bool? isOnline,
    bool? isVerified,
    String? vehicleType,
    String? vehiclePlate,
    DateTime? createdAt,
  }) {
    return DriverProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      createdAt: createdAt ?? this.createdAt,
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
