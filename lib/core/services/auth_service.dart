import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/api_constants.dart';

class OtpRequestResponse {
  final String message;
  final String? sessionId;
  final String? debugOtp; // OTP code returned for debugging

  OtpRequestResponse({required this.message, this.sessionId, this.debugOtp});

  factory OtpRequestResponse.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponse(
      message: json['message'] ?? 'OTP sent successfully',
      sessionId: json['session_id'],
      debugOtp: json['otp']?.toString() ?? json['code']?.toString(),
    );
  }
}

class OtpVerifyResponse {
  final String accessToken;
  final String refreshToken;
  final bool isNewUser;
  final String? userId;

  OtpVerifyResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.isNewUser,
    this.userId,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      accessToken: json['access'] ?? json['access_token'] ?? '',
      refreshToken: json['refresh'] ?? json['refresh_token'] ?? '',
      isNewUser: json['is_new_user'] ?? false,
      userId: json['user_id']?.toString(),
    );
  }
}

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  ApiClient get apiClient => _apiClient;

  /// Set callback to handle token refresh failures
  void setTokenRefreshFailedCallback(void Function() callback) {
    _apiClient.onTokenRefreshFailed = callback;
  }

  Future<OtpRequestResponse> requestOtp(String phoneNumber) async {
    try {
      debugPrint(
        '[AuthService] Sending OTP request to: ${ApiConstants.otpRequest}',
      );
      final response = await _apiClient.post(
        ApiConstants.otpRequest,
        data: {'phone': phoneNumber},
      );

      debugPrint('[AuthService] OTP response status: ${response.statusCode}');
      debugPrint('[AuthService] OTP response data: ${response.data}');
      return OtpRequestResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint(
        '[AuthService] DioException: ${e.message}, response: ${e.response?.data}',
      );
      throw ApiException.fromDioException(e);
    }
  }

  Future<OtpVerifyResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      debugPrint('[AuthService] === OTP VERIFY REQUEST ===');
      debugPrint('[AuthService] Endpoint: ${ApiConstants.otpVerify}');
      debugPrint('[AuthService] Data: {phone: $phoneNumber, otp: $otp}');

      final response = await _apiClient.post(
        ApiConstants.otpVerify,
        data: {'phone': phoneNumber, 'code': otp},
      );

      debugPrint('[AuthService] === OTP VERIFY RESPONSE ===');
      debugPrint('[AuthService] Status: ${response.statusCode}');
      debugPrint('[AuthService] Data: ${response.data}');

      final otpResponse = OtpVerifyResponse.fromJson(response.data);

      // Save tokens
      await _apiClient.tokenStorage.saveTokens(
        accessToken: otpResponse.accessToken,
        refreshToken: otpResponse.refreshToken,
      );

      debugPrint('[AuthService] Tokens saved successfully');
      debugPrint('[AuthService] isNewUser: ${otpResponse.isNewUser}');

      return otpResponse;
    } on DioException catch (e) {
      debugPrint('[AuthService] OTP Verify Error: ${e.message}');
      debugPrint('[AuthService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      debugPrint('[AuthService] === LOGOUT REQUEST ===');
      final refreshToken = await _apiClient.tokenStorage.getRefreshToken();
      debugPrint('[AuthService] Has refresh token: ${refreshToken != null}');

      if (refreshToken != null) {
        debugPrint('[AuthService] Endpoint: ${ApiConstants.logout}');
        final response = await _apiClient.post(
          ApiConstants.logout,
          data: {'refresh': refreshToken},
        );
        debugPrint('[AuthService] === LOGOUT RESPONSE ===');
        debugPrint('[AuthService] Status: ${response.statusCode}');
        debugPrint('[AuthService] Data: ${response.data}');
      }
    } catch (e) {
      debugPrint('[AuthService] Logout Error (ignored): $e');
      // Ignore errors during logout API call
    } finally {
      await _apiClient.tokenStorage.clearTokens();
      debugPrint('[AuthService] Tokens cleared');
    }
  }

  Future<void> deleteAccount() async {
    try {
      debugPrint('[AuthService] === DELETE ACCOUNT REQUEST ===');
      debugPrint('[AuthService] Endpoint: ${ApiConstants.userMe}');

      final response = await _apiClient.delete(ApiConstants.userMe);

      debugPrint('[AuthService] === DELETE ACCOUNT RESPONSE ===');
      debugPrint('[AuthService] Status: ${response.statusCode}');
      debugPrint('[AuthService] Account deleted successfully');
    } on DioException catch (e) {
      debugPrint('[AuthService] Delete Account Error: ${e.message}');
      debugPrint('[AuthService] Error Response: ${e.response?.data}');
      throw ApiException.fromDioException(e);
    } finally {
      // Always clear tokens after account deletion attempt
      await _apiClient.tokenStorage.clearTokens();
      debugPrint('[AuthService] Tokens cleared after account deletion');
    }
  }

  Future<bool> isAuthenticated() async {
    return _apiClient.hasValidSession();
  }
}
