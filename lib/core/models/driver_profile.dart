import '../utils/birthdate_utils.dart';
import 'driver_address.dart';

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
  final String? status; // PENDING, APPROVED, REJECTED, etc.
  final List<String> roles;
  final String? vehicleType;
  final String? vehiclePlate;
  final String? carSize;
  final DateTime? birthdate;
  final String? vehiclePlateNumber;
  final String? vehicleColor;
  final String? vehicleMake;
  final String? vehicleModel;
  final int? vehicleYear;
  final bool acceptsFood;
  final bool acceptsShipping;
  final bool acceptsTaxi;
  final String? drivingLicense;
  final String? idDocument;
  final String? otherDocuments;
  final String? healthInsuranceDocument;
  final String? addressDocument;
  final DriverAddress? address;
  final String? bankDocument;
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
    this.status,
    this.roles = const [],
    this.vehicleType,
    this.vehiclePlate,
    this.carSize,
    this.birthdate,
    this.vehiclePlateNumber,
    this.vehicleColor,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleYear,
    this.acceptsFood = false,
    this.acceptsShipping = false,
    this.acceptsTaxi = false,
    this.drivingLicense,
    this.idDocument,
    this.otherDocuments,
    this.healthInsuranceDocument,
    this.addressDocument,
    this.address,
    this.bankDocument,
    this.createdAt,
  });

  String get fullName {
    if (firstName == null && lastName == null) return 'Driver';
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  String get formattedRating => rating.toStringAsFixed(1);
  int? get age =>
      birthdate == null ? null : BirthdateUtils.calculateAge(birthdate!);

  String get formattedEarnings {
    if (totalEarnings >= 1000) {
      return '\$${(totalEarnings / 1000).toStringAsFixed(1)}K';
    }
    return '\$${totalEarnings.toStringAsFixed(2)}';
  }

  String get memberSince {
    if (createdAt == null) return 'N/A';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[createdAt!.month - 1]} ${createdAt!.year.toString().substring(2)}';
  }

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    // Handle nested user object if present
    final user = json['user'] as Map<String, dynamic>? ?? json;

    // Parse name: try first_name/last_name, then fall back to single 'name' field
    String? firstName = user['first_name'] ?? json['first_name'];
    String? lastName = user['last_name'] ?? json['last_name'];
    if (firstName == null && lastName == null) {
      final fullName =
          (user['name'] ??
                  json['name'] ??
                  json['full_name'] ??
                  user['full_name'])
              as String?;
      if (fullName != null && fullName.trim().isNotEmpty) {
        final parts = fullName.trim().split(RegExp(r'\s+'));
        firstName = parts.first;
        lastName = parts.length > 1 ? parts.sublist(1).join(' ') : null;
      }
    }

    // Parse roles
    final rolesList = <String>[];
    final rolesRaw = json['roles'];
    if (rolesRaw is List) {
      for (final r in rolesRaw) {
        if (r is String) rolesList.add(r);
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
      isVerified:
          json['is_verified'] ??
          json['verified'] ??
          json['status'] == 'APPROVED',
      status: json['status'] as String?,
      roles: rolesList,
      vehicleType: json['vehicle_type'],
      vehiclePlate: json['vehicle_plate'] ?? json['license_plate'],
      carSize: json['car_size'] as String?,
      birthdate: BirthdateUtils.parse(json['birthdate'] ?? user['birthdate']),
      vehiclePlateNumber: json['vehicle_plate_number'],
      vehicleColor: json['vehicle_color'],
      vehicleMake: json['vehicle_make'],
      vehicleModel: json['vehicle_model'],
      vehicleYear: _parseInt(json['vehicle_year']),
      acceptsFood: json['accepts_food'] ?? false,
      acceptsShipping: json['accepts_shipping'] ?? false,
      acceptsTaxi: json['accepts_taxi'] ?? false,
      drivingLicense: _parseNullableUrl(json['driving_license']),
      idDocument: _parseNullableUrl(json['id_document']),
      otherDocuments: _parseNullableUrl(json['other_documents']),
      healthInsuranceDocument: _parseNullableUrl(
        json['health_insurance_document'],
      ),
      addressDocument: _parseNullableUrl(json['address_document']),
      address: _parseAddress(json['address']),
      bankDocument: _parseNullableUrl(json['bank_document']),
      createdAt: _parseDateTime(json['created_at'] ?? user['date_joined']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'birthdate': birthdate == null
          ? null
          : BirthdateUtils.formatForApi(birthdate!),
      'vehicle_type': vehicleType,
      'vehicle_plate': vehiclePlate,
    };
    if (address != null && address!.hasAnyValue) {
      data['address'] = address!.toPatchJson();
    }
    return data;
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
    String? status,
    List<String>? roles,
    String? vehicleType,
    String? vehiclePlate,
    String? carSize,
    DateTime? birthdate,
    String? vehiclePlateNumber,
    String? vehicleColor,
    String? vehicleMake,
    String? vehicleModel,
    int? vehicleYear,
    bool? acceptsFood,
    bool? acceptsShipping,
    bool? acceptsTaxi,
    String? drivingLicense,
    String? idDocument,
    String? otherDocuments,
    String? healthInsuranceDocument,
    String? addressDocument,
    DriverAddress? address,
    String? bankDocument,
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
      status: status ?? this.status,
      roles: roles ?? this.roles,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      carSize: carSize ?? this.carSize,
      birthdate: birthdate ?? this.birthdate,
      vehiclePlateNumber: vehiclePlateNumber ?? this.vehiclePlateNumber,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleMake: vehicleMake ?? this.vehicleMake,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      acceptsFood: acceptsFood ?? this.acceptsFood,
      acceptsShipping: acceptsShipping ?? this.acceptsShipping,
      acceptsTaxi: acceptsTaxi ?? this.acceptsTaxi,
      drivingLicense: drivingLicense ?? this.drivingLicense,
      idDocument: idDocument ?? this.idDocument,
      otherDocuments: otherDocuments ?? this.otherDocuments,
      healthInsuranceDocument:
          healthInsuranceDocument ?? this.healthInsuranceDocument,
      addressDocument: addressDocument ?? this.addressDocument,
      address: address ?? this.address,
      bankDocument: bankDocument ?? this.bankDocument,
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

  /// Parse a URL string, returning null for empty/blank values
  static String? _parseNullableUrl(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty) return null;
    return str;
  }

  static DriverAddress? _parseAddress(dynamic value) {
    if (value is! Map) return null;
    return DriverAddress.fromJson(Map<String, dynamic>.from(value));
  }
}
