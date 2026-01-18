import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../models/notification_model.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Register or update an FCM device token for the authenticated user
  Future<void> registerDeviceToken({
    required String token,
    required String deviceType,
  }) async {
    try {
      debugPrint('[NotificationService] === REGISTER DEVICE TOKEN REQUEST ===');
      debugPrint('[NotificationService] Endpoint: ${ApiConstants.deviceToken}');
      debugPrint('[NotificationService] Data: {token: ${token.substring(0, 20)}..., device_type: $deviceType}');

      final response = await _apiClient.post(
        ApiConstants.deviceToken,
        data: {
          'token': token,
          'device_type': deviceType,
        },
      );

      debugPrint('[NotificationService] === REGISTER DEVICE TOKEN RESPONSE ===');
      debugPrint('[NotificationService] Status: ${response.statusCode}');
      debugPrint('[NotificationService] Data: ${response.data}');
    } on DioException catch (e) {
      debugPrint('[NotificationService] Register Device Token Error: ${e.message}');
      debugPrint('[NotificationService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  /// Get all notifications for the authenticated user
  Future<List<NotificationModel>> getNotifications() async {
    try {
      debugPrint('[NotificationService] === GET NOTIFICATIONS REQUEST ===');
      debugPrint('[NotificationService] Endpoint: ${ApiConstants.notifications}');

      final response = await _apiClient.get(ApiConstants.notifications);

      debugPrint('[NotificationService] === GET NOTIFICATIONS RESPONSE ===');
      debugPrint('[NotificationService] Status: ${response.statusCode}');
      debugPrint('[NotificationService] Data: ${response.data}');

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('[NotificationService] Get Notifications Error: ${e.message}');
      debugPrint('[NotificationService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }
}
