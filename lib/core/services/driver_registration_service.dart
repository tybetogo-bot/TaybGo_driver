import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../models/driver_address.dart';
import '../utils/birthdate_utils.dart';

class DriverRegistrationService {
  final ApiClient _apiClient;

  DriverRegistrationService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Register a new driver
  /// POST /api/driver/profile/
  Future<DriverRegistrationResult> registerDriver({
    required String name,
    required String phone,
    required DateTime birthdate,
    required String vehicleType,
    String? carSize,
    String? vehiclePlateNumber,
    String? vehicleColor,
    String? vehicleMake,
    String? vehicleModel,
    int? vehicleYear,
    required bool acceptsFood,
    required bool acceptsShipping,
    required bool acceptsTaxi,
    String? drivingLicense,
    String? idDocument,
    String? otherDocuments,
    String? healthInsuranceDocument,
    String? addressDocument,
    String? bankDocument,
    DriverAddress? address,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        'phone': phone,
        'birthdate': BirthdateUtils.formatForApi(birthdate),
        'vehicle_type': vehicleType,
        'accepts_food': acceptsFood,
        'accepts_shipping': acceptsShipping,
        'accepts_taxi': acceptsTaxi,
      };

      if (carSize != null && carSize.trim().isNotEmpty) {
        data['car_size'] = carSize.trim();
      }
      if (vehiclePlateNumber != null && vehiclePlateNumber.trim().isNotEmpty) {
        data['vehicle_plate_number'] = vehiclePlateNumber.trim();
      }
      if (vehicleColor != null && vehicleColor.trim().isNotEmpty) {
        data['vehicle_color'] = vehicleColor.trim();
      }
      if (vehicleMake != null && vehicleMake.trim().isNotEmpty) {
        data['vehicle_make'] = vehicleMake.trim();
      }
      if (vehicleModel != null && vehicleModel.trim().isNotEmpty) {
        data['vehicle_model'] = vehicleModel.trim();
      }
      if (vehicleYear != null) {
        data['vehicle_year'] = vehicleYear;
      }

      // Add documents if provided
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
      if (address != null) {
        final addressData = address.toCreateJson();
        if (addressData.isNotEmpty) {
          data['address'] = addressData;
        }
      }

      debugPrint('[DriverRegistrationService] === REGISTER DRIVER REQUEST ===');
      debugPrint(
        '[DriverRegistrationService] Endpoint: ${ApiConstants.driverCreate}',
      );
      debugPrint('[DriverRegistrationService] Data: $data');

      final response = await _apiClient.post(
        ApiConstants.driverCreate,
        data: data,
      );

      debugPrint(
        '[DriverRegistrationService] === REGISTER DRIVER RESPONSE ===',
      );
      debugPrint('[DriverRegistrationService] Status: ${response.statusCode}');
      debugPrint('[DriverRegistrationService] Data: ${response.data}');

      final responseData = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final responseAddress = responseData['address'];

      return DriverRegistrationResult(
        success: true,
        message: responseData['message'] ?? 'Registration successful',
        driverId: responseData['id']?.toString(),
        isVerified:
            responseData['is_verified'] ?? responseData['verified'] ?? false,
        address: responseAddress is Map
            ? DriverAddress.fromJson(Map<String, dynamic>.from(responseAddress))
            : null,
      );
    } on DioException catch (e) {
      debugPrint(
        '[DriverRegistrationService] Register Driver Error: ${e.message}',
      );
      debugPrint(
        '[DriverRegistrationService] Error Response: ${e.response?.data}',
      );

      if (e.response?.statusCode == 400) {
        final errors = e.response?.data;
        String message = 'Validation error';
        if (errors is Map) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            message = firstError.first.toString();
          } else if (firstError is String) {
            message = firstError;
          }
        }
        debugPrint('[DriverRegistrationService] Validation Error: $message');
        return DriverRegistrationResult(success: false, message: message);
      }
      if (e.response?.statusCode == 409) {
        debugPrint('[DriverRegistrationService] Duplicate phone number');
        return DriverRegistrationResult(
          success: false,
          message: 'A driver with this phone number already exists',
        );
      }
      throw ApiException.fromDioException(e);
    }
  }
}

class DriverRegistrationResult {
  final bool success;
  final String message;
  final String? driverId;
  final bool isVerified;
  final DriverAddress? address;

  DriverRegistrationResult({
    required this.success,
    required this.message,
    this.driverId,
    this.isVerified = false,
    this.address,
  });
}
