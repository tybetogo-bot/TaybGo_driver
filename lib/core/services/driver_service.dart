import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../models/driver_profile.dart';

class DriverService {
  final ApiClient _apiClient;

  DriverService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<DriverProfile> getProfile() async {
    try {
      debugPrint('[DriverService] === GET PROFILE REQUEST ===');
      debugPrint('[DriverService] Endpoint: ${ApiConstants.driverProfile}');

      final response = await _apiClient.get(ApiConstants.driverProfile);

      debugPrint('[DriverService] === GET PROFILE RESPONSE ===');
      debugPrint('[DriverService] Status: ${response.statusCode}');
      debugPrint('[DriverService] Data: ${response.data}');

      return DriverProfile.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('[DriverService] Get Profile Error: ${e.message}');
      debugPrint('[DriverService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  Future<DriverProfile> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? vehicleType,
    String? vehiclePlate,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (email != null) data['email'] = email;
      if (vehicleType != null) data['vehicle_type'] = vehicleType;
      if (vehiclePlate != null) data['vehicle_plate'] = vehiclePlate;

      debugPrint('[DriverService] === UPDATE PROFILE REQUEST ===');
      debugPrint('[DriverService] Endpoint: ${ApiConstants.driverProfile}');
      debugPrint('[DriverService] Data: $data');

      final response = await _apiClient.patch(
        ApiConstants.driverProfile,
        data: data,
      );

      debugPrint('[DriverService] === UPDATE PROFILE RESPONSE ===');
      debugPrint('[DriverService] Status: ${response.statusCode}');
      debugPrint('[DriverService] Data: ${response.data}');

      return DriverProfile.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('[DriverService] Update Profile Error: ${e.message}');
      debugPrint('[DriverService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  Future<bool> toggleOnlineStatus(bool isOnline) async {
    try {
      debugPrint('[DriverService] === TOGGLE ONLINE STATUS REQUEST ===');
      debugPrint('[DriverService] Endpoint: ${ApiConstants.driverToggleOnline}');
      debugPrint('[DriverService] Data: {is_online: $isOnline}');

      final response = await _apiClient.post(
        ApiConstants.driverToggleOnline,
        data: {'is_online': isOnline},
      );

      debugPrint('[DriverService] === TOGGLE ONLINE STATUS RESPONSE ===');
      debugPrint('[DriverService] Status: ${response.statusCode}');
      debugPrint('[DriverService] Data: ${response.data}');

      return response.data['is_online'] ?? isOnline;
    } on DioException catch (e) {
      debugPrint('[DriverService] Toggle Online Error: ${e.message}');
      debugPrint('[DriverService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Round to 6 decimal places (backend requirement)
      final lat = double.parse(latitude.toStringAsFixed(6));
      final lng = double.parse(longitude.toStringAsFixed(6));

      final requestData = {
        'lat': lat,
        'lng': lng,
      };

      debugPrint('[DriverService] === UPDATE LOCATION REQUEST ===');
      debugPrint('[DriverService] Endpoint: ${ApiConstants.baseUrl}${ApiConstants.driverLocation}');
      debugPrint('[DriverService] Method: POST');
      debugPrint('[DriverService] Request Body: $requestData');

      final response = await _apiClient.post(
        ApiConstants.driverLocation,
        data: requestData,
      );

      debugPrint('[DriverService] === UPDATE LOCATION RESPONSE ===');
      debugPrint('[DriverService] Status Code: ${response.statusCode}');
      debugPrint('[DriverService] Status Message: ${response.statusMessage}');
      debugPrint('[DriverService] Headers: ${response.headers.map}');
      debugPrint('[DriverService] Raw Data Type: ${response.data.runtimeType}');
      debugPrint('[DriverService] Raw Data: ${response.data}');
    } on DioException catch (e) {
      debugPrint('[DriverService] Update Location Error: ${e.message}');
      debugPrint('[DriverService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }
}
