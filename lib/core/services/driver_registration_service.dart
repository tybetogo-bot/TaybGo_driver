import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_constants.dart';

class DriverRegistrationService {
  final ApiClient _apiClient;

  DriverRegistrationService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Register a new driver
  /// POST /api/drivers/
  Future<DriverRegistrationResult> registerDriver({
    required String name,
    required String email,
    required String phone,
    required int age,
    required String vehicleType,
    required bool acceptsFood,
    required bool acceptsShipping,
    required bool acceptsTaxi,
    String? drivingLicense,
    String? idDocument,
    String? otherDocuments,
  }) async {
    try {
      final data = {
        'name': name,
        'email': email,
        'phone': phone,
        'age': age,
        'vehicle_type': vehicleType,
        'accepts_food': acceptsFood,
        'accepts_shipping': acceptsShipping,
        'accepts_taxi': acceptsTaxi,
      };

      // Add documents if provided
      if (drivingLicense != null) {
        data['driving_license'] = drivingLicense;
      }
      if (idDocument != null) {
        data['id_document'] = idDocument;
      }
      if (otherDocuments != null) {
        data['other_documents'] = otherDocuments;
      }

      debugPrint('[DriverRegistrationService] === REGISTER DRIVER REQUEST ===');
      debugPrint('[DriverRegistrationService] Endpoint: ${ApiConstants.driverCreate}');
      debugPrint('[DriverRegistrationService] Data: $data');

      final response = await _apiClient.post(
        ApiConstants.driverCreate,
        data: data,
      );

      debugPrint('[DriverRegistrationService] === REGISTER DRIVER RESPONSE ===');
      debugPrint('[DriverRegistrationService] Status: ${response.statusCode}');
      debugPrint('[DriverRegistrationService] Data: ${response.data}');

      return DriverRegistrationResult(
        success: true,
        message: response.data['message'] ?? 'Registration successful',
        driverId: response.data['id']?.toString(),
      );
    } on DioException catch (e) {
      debugPrint('[DriverRegistrationService] Register Driver Error: ${e.message}');
      debugPrint('[DriverRegistrationService] Error Response: ${e.response?.data}');

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
        return DriverRegistrationResult(
          success: false,
          message: message,
        );
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

  DriverRegistrationResult({
    required this.success,
    required this.message,
    this.driverId,
  });
}
