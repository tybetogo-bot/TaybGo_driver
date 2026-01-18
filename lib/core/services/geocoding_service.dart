import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeocodingService {
  static final GeocodingService _instance = GeocodingService._internal();
  factory GeocodingService() => _instance;
  GeocodingService._internal();

  String? _cachedPlaceName;
  double? _cachedLat;
  double? _cachedLng;

  /// Get place name from coordinates using Nominatim (OpenStreetMap)
  /// Returns a short, user-friendly place name
  Future<String?> getPlaceName(double latitude, double longitude) async {
    // Check cache - if within ~100m of cached location, return cached name
    if (_cachedPlaceName != null && _cachedLat != null && _cachedLng != null) {
      final latDiff = (latitude - _cachedLat!).abs();
      final lngDiff = (longitude - _cachedLng!).abs();
      // ~0.001 degrees is roughly 100m
      if (latDiff < 0.001 && lngDiff < 0.001) {
        return _cachedPlaceName;
      }
    }

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'TeybatDriver/1.0',
          'Accept-Language': 'en',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final placeName = _extractPlaceName(data);

        // Cache the result
        _cachedPlaceName = placeName;
        _cachedLat = latitude;
        _cachedLng = longitude;

        debugPrint('[GeocodingService] Place: $placeName');
        return placeName;
      }
    } catch (e) {
      debugPrint('[GeocodingService] Error: $e');
    }
    return null;
  }

  String _extractPlaceName(Map<String, dynamic> data) {
    final address = data['address'] as Map<String, dynamic>?;
    if (address == null) {
      return data['display_name']?.toString().split(',').first ?? 'Unknown';
    }

    // Priority order for place name
    final placeName = address['road'] ??
        address['neighbourhood'] ??
        address['suburb'] ??
        address['quarter'] ??
        address['hamlet'] ??
        address['village'] ??
        address['town'] ??
        address['city'] ??
        address['municipality'];

    final area = address['suburb'] ??
        address['neighbourhood'] ??
        address['quarter'] ??
        address['city_district'] ??
        address['city'] ??
        address['town'];

    if (placeName != null && area != null && placeName != area) {
      return '$placeName, $area';
    }

    return placeName?.toString() ?? area?.toString() ?? 'Unknown location';
  }

  void clearCache() {
    _cachedPlaceName = null;
    _cachedLat = null;
    _cachedLng = null;
  }
}
