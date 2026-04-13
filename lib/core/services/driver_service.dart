import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../models/driver_profile.dart';
import '../utils/birthdate_utils.dart';

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
      // Debug document fields specifically
      if (response.data is Map) {
        debugPrint(
          '[DriverService] driving_license: ${response.data['driving_license']}',
        );
        debugPrint(
          '[DriverService] id_document: ${response.data['id_document']}',
        );
        debugPrint(
          '[DriverService] other_documents: ${response.data['other_documents']}',
        );
        debugPrint(
          '[DriverService] health_insurance_document: ${response.data['health_insurance_document']}',
        );
        debugPrint(
          '[DriverService] address_document: ${response.data['address_document']}',
        );
        debugPrint(
          '[DriverService] bank_document: ${response.data['bank_document']}',
        );
      }

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

  Future<void> updateUserProfile({
    String? name,
    String? phone,
    DateTime? birthdate,
    String? vehicleType,
    bool clearCarDetails = false,
    String? carSize,
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
    String? bankDocument,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) {
        data['name'] = name;
      }
      if (phone != null) {
        data['phone'] = phone;
      }
      if (birthdate != null) {
        data['birthdate'] = BirthdateUtils.formatForApi(birthdate);
      }
      if (vehicleType != null) {
        data['vehicle_type'] = vehicleType;
      }
      if (clearCarDetails) {
        data['car_size'] = null;
        data['vehicle_plate_number'] = null;
        data['vehicle_color'] = null;
        data['vehicle_make'] = null;
        data['vehicle_model'] = null;
        data['vehicle_year'] = null;
      } else if (carSize != null) {
        data['car_size'] = carSize;
      }
      if (!clearCarDetails && vehiclePlateNumber != null) {
        data['vehicle_plate_number'] = vehiclePlateNumber;
      }
      if (!clearCarDetails && vehicleColor != null) {
        data['vehicle_color'] = vehicleColor;
      }
      if (!clearCarDetails && vehicleMake != null) {
        data['vehicle_make'] = vehicleMake;
      }
      if (!clearCarDetails && vehicleModel != null) {
        data['vehicle_model'] = vehicleModel;
      }
      if (!clearCarDetails && vehicleYear != null) {
        data['vehicle_year'] = vehicleYear;
      }
      if (acceptsFood != null) {
        data['accepts_food'] = acceptsFood;
      }
      if (acceptsShipping != null) {
        data['accepts_shipping'] = acceptsShipping;
      }
      if (acceptsTaxi != null) {
        data['accepts_taxi'] = acceptsTaxi;
      }
      if (drivingLicense != null) {
        data['driving_license'] = drivingLicense;
      }
      if (idDocument != null) {
        data['id_document'] = idDocument;
      }
      if (healthInsuranceDocument != null) {
        data['health_insurance_document'] = healthInsuranceDocument;
      }
      if (addressDocument != null) {
        data['address_document'] = addressDocument;
      }
      if (bankDocument != null) {
        data['bank_document'] = bankDocument;
      }
      if (otherDocuments != null) {
        data['other_documents'] = otherDocuments;
      }

      debugPrint('[DriverService] === UPDATE USER PROFILE REQUEST ===');
      debugPrint('[DriverService] Endpoint: ${ApiConstants.driverProfile}');
      debugPrint('[DriverService] Data: $data');

      final response = await _apiClient.patch(
        ApiConstants.driverProfile,
        data: data,
      );

      debugPrint('[DriverService] === UPDATE USER PROFILE RESPONSE ===');
      debugPrint('[DriverService] Status: ${response.statusCode}');
      debugPrint('[DriverService] Data: ${response.data}');
      // Debug document fields in response
      if (response.data is Map) {
        debugPrint(
          '[DriverService] Response driving_license: ${response.data['driving_license']}',
        );
        debugPrint(
          '[DriverService] Response id_document: ${response.data['id_document']}',
        );
        debugPrint(
          '[DriverService] Response other_documents: ${response.data['other_documents']}',
        );
        debugPrint(
          '[DriverService] Response health_insurance_document: ${response.data['health_insurance_document']}',
        );
        debugPrint(
          '[DriverService] Response address_document: ${response.data['address_document']}',
        );
        debugPrint(
          '[DriverService] Response bank_document: ${response.data['bank_document']}',
        );
      }
    } on DioException catch (e) {
      debugPrint('[DriverService] Update User Profile Error: ${e.message}');
      debugPrint('[DriverService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  Future<bool> toggleOnlineStatus(bool isOnline) async {
    try {
      debugPrint('[DriverService] === TOGGLE ONLINE STATUS REQUEST ===');
      debugPrint(
        '[DriverService] Endpoint: ${ApiConstants.driverToggleOnline}',
      );
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

      final requestData = {'lat': lat, 'lng': lng};

      debugPrint('[DriverService] === UPDATE LOCATION REQUEST ===');
      debugPrint(
        '[DriverService] Endpoint: ${ApiConstants.baseUrl}${ApiConstants.driverLocation}',
      );
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
