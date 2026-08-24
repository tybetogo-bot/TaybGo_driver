class DriverAddress {
  final String? label;
  final String? lat;
  final String? lng;
  final String? fullAddress;
  final String? streetName;
  final String? houseNumber;
  final String? city;
  final String? postalCode;
  final String? country;

  const DriverAddress({
    this.label,
    this.lat,
    this.lng,
    this.fullAddress,
    this.streetName,
    this.houseNumber,
    this.city,
    this.postalCode,
    this.country,
  });

  factory DriverAddress.fromJson(Map<String, dynamic> json) {
    String? readString(dynamic value) {
      if (value == null) return null;
      final normalized = value.toString().trim();
      return normalized.isEmpty ? null : normalized;
    }

    return DriverAddress(
      label: readString(json['label']),
      lat: readString(json['lat']),
      lng: readString(json['lng']),
      fullAddress: readString(json['full_address']),
      streetName: readString(json['street_name']),
      houseNumber: readString(json['house_number']),
      city: readString(json['city']),
      postalCode: readString(json['postal_code']),
      country: readString(json['country']),
    );
  }

  /// Whether the address contains at least one usable value.
  bool get hasAnyValue => toPatchJson().isNotEmpty;

  /// Serialize a partial address update without sending null values.
  Map<String, dynamic> toPatchJson() {
    final data = <String, dynamic>{};

    void add(String key, String? value) {
      final normalized = value?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        data[key] = normalized;
      }
    }

    add('label', label);
    add('lat', lat);
    add('lng', lng);
    add('full_address', fullAddress);
    add('street_name', streetName);
    add('house_number', houseNumber);
    add('city', city);
    add('postal_code', postalCode);
    add('country', country);

    return data;
  }

  /// Serialize a first address and enforce the backend's required fields.
  Map<String, dynamic> toCreateJson() {
    final requiredFields = <String, String?>{
      'label': label,
      'lat': lat,
      'lng': lng,
      'full_address': fullAddress,
    };

    final missing = requiredFields.entries
        .where((entry) => entry.value == null || entry.value!.trim().isEmpty)
        .map((entry) => entry.key)
        .toList();
    if (missing.isNotEmpty) {
      throw ArgumentError(
        'Missing required address fields: ${missing.join(', ')}',
      );
    }

    return toPatchJson();
  }

  DriverAddress copyWith({
    String? label,
    String? lat,
    String? lng,
    String? fullAddress,
    String? streetName,
    String? houseNumber,
    String? city,
    String? postalCode,
    String? country,
  }) {
    return DriverAddress(
      label: label ?? this.label,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      fullAddress: fullAddress ?? this.fullAddress,
      streetName: streetName ?? this.streetName,
      houseNumber: houseNumber ?? this.houseNumber,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }
}
