import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';
import 'token_storage.dart';

class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;
  late final _AuthInterceptor _authInterceptor;

  /// Callback invoked when token refresh fails and tokens are cleared.
  /// Use this to trigger logout in your auth provider.
  void Function()? onTokenRefreshFailed;

  ApiClient({TokenStorage? tokenStorage})
    : _tokenStorage = tokenStorage ?? TokenStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _authInterceptor = _AuthInterceptor(_dio, _tokenStorage, this);
    _dio.interceptors.add(_authInterceptor);
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Dio get dio => _dio;
  TokenStorage get tokenStorage => _tokenStorage;

  Future<bool> hasValidSession() {
    return _authInterceptor.validateStoredSession();
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> patch<T>(String path, {dynamic data, Options? options}) {
    return _dio.patch<T>(path, data: data, options: options);
  }

  Future<Response<T>> delete<T>(String path, {Options? options}) {
    return _dio.delete<T>(path, options: options);
  }
}

class _AuthInterceptor extends QueuedInterceptor {
  static const Duration _tokenExpiryLeeway = Duration(seconds: 30);

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final ApiClient _apiClient;
  bool _isRefreshing = false;

  _AuthInterceptor(this._dio, this._tokenStorage, this._apiClient);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for public endpoints.
    final publicEndpoints = [
      ApiConstants.otpRequest,
      ApiConstants.otpVerify,
      ApiConstants.tokenRefresh,
    ];

    final isPublic = publicEndpoints.any(
      (endpoint) => options.path == endpoint || options.path.endsWith(endpoint),
    );
    debugPrint('[AuthInterceptor] Request: ${options.path}');
    debugPrint('[AuthInterceptor] Is public endpoint: $isPublic');

    if (!isPublic) {
      final token = await _getUsableAccessToken();
      debugPrint(
        '[AuthInterceptor] Using valid access token: ${token != null}',
      );
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  Future<bool> validateStoredSession() async {
    final accessToken = await _tokenStorage.getAccessToken();
    final refreshToken = await _tokenStorage.getRefreshToken();

    final hasStoredSession =
        (accessToken != null && accessToken.isNotEmpty) ||
        (refreshToken != null && refreshToken.isNotEmpty);

    if (!hasStoredSession) {
      debugPrint('[AuthInterceptor] No stored session found');
      return false;
    }

    final accessState = _inspectToken(accessToken, label: 'access');
    final refreshState = _inspectToken(refreshToken, label: 'refresh');

    if (accessState.isValid && refreshState.isValid) {
      debugPrint('[AuthInterceptor] Stored session is valid');
      return true;
    }

    if (!refreshState.isValid) {
      debugPrint(
        '[AuthInterceptor] Stored session invalid: access=${accessState.reason}, refresh=${refreshState.reason}',
      );
      await _forceLogout();
      return false;
    }

    debugPrint(
      '[AuthInterceptor] Access token is ${accessState.reason}; attempting refresh with stored refresh token',
    );
    return _refreshSession(refreshToken: refreshToken!);
  }

  /// Check if the error response indicates a token/auth problem.
  bool _isTokenError(DioException err) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      return true;
    }

    final data = err.response?.data;
    if (data is Map) {
      final detail = (data['detail'] ?? data['message'] ?? data['code'] ?? '')
          .toString()
          .toLowerCase();
      const tokenErrors = [
        'token_not_valid',
        'token is invalid',
        'token is expired',
        'token has been blacklisted',
        'token is blacklisted',
        'invalid token',
        'expired token',
        'authentication credentials were not provided',
      ];
      if (tokenErrors.any((message) => detail.contains(message))) {
        return true;
      }
    }

    return false;
  }

  Future<String?> _getUsableAccessToken() async {
    final accessToken = await _tokenStorage.getAccessToken();
    final accessState = _inspectToken(accessToken, label: 'access');

    if (accessState.isValid) {
      return accessToken;
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    final refreshState = _inspectToken(refreshToken, label: 'refresh');

    if (!refreshState.isValid) {
      if ((accessToken != null && accessToken.isNotEmpty) ||
          (refreshToken != null && refreshToken.isNotEmpty)) {
        debugPrint(
          '[AuthInterceptor] No usable refresh token available (${refreshState.reason}); forcing logout',
        );
        await _forceLogout();
      }
      return null;
    }

    debugPrint(
      '[AuthInterceptor] Access token is ${accessState.reason}; refreshing before request',
    );
    final refreshed = await _refreshSession(refreshToken: refreshToken!);
    if (!refreshed) {
      return null;
    }

    return _tokenStorage.getAccessToken();
  }

  Future<bool> _refreshSession({required String refreshToken}) async {
    if (_isRefreshing) {
      debugPrint(
        '[AuthInterceptor] Refresh already in progress; waiting for updated tokens',
      );
      return _waitForRefreshCompletion();
    }

    _isRefreshing = true;

    try {
      final response = await Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ).post(ApiConstants.tokenRefresh, data: {'refresh': refreshToken});

      debugPrint('[AuthInterceptor] Refresh response: ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint(
          '[AuthInterceptor] Refresh returned ${response.statusCode}, forcing logout',
        );
        await _forceLogout();
        return false;
      }

      final newAccessToken = response.data['access'] as String?;
      final newRefreshToken =
          response.data['refresh'] as String? ?? refreshToken;

      final newAccessState = _inspectToken(
        newAccessToken,
        label: 'refreshed access',
      );
      final newRefreshState = _inspectToken(
        newRefreshToken,
        label: 'refreshed refresh',
      );

      if (!newAccessState.isValid || !newRefreshState.isValid) {
        debugPrint(
          '[AuthInterceptor] Refresh produced invalid tokens: access=${newAccessState.reason}, refresh=${newRefreshState.reason}',
        );
        await _forceLogout();
        return false;
      }

      await _tokenStorage.saveTokens(
        accessToken: newAccessToken!,
        refreshToken: newRefreshToken,
      );
      debugPrint('[AuthInterceptor] New tokens saved');
      return true;
    } catch (e) {
      debugPrint('[AuthInterceptor] Token refresh failed: $e');
      await _forceLogout();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<bool> _waitForRefreshCompletion() async {
    while (_isRefreshing) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

    final refreshedAccessToken = await _tokenStorage.getAccessToken();
    return _inspectToken(
      refreshedAccessToken,
      label: 'access after waiting for refresh',
    ).isValid;
  }

  _TokenInspectionResult _inspectToken(String? token, {required String label}) {
    if (token == null || token.isEmpty) {
      return const _TokenInspectionResult(isValid: false, reason: 'missing');
    }

    final payload = _decodeJwtPayload(token);
    if (payload == null) {
      debugPrint('[AuthInterceptor] $label token is malformed');
      return const _TokenInspectionResult(isValid: false, reason: 'malformed');
    }

    final expValue = payload['exp'];
    final expSeconds = expValue is int
        ? expValue
        : int.tryParse(expValue?.toString() ?? '');

    if (expSeconds == null) {
      debugPrint('[AuthInterceptor] $label token is missing exp');
      return const _TokenInspectionResult(
        isValid: false,
        reason: 'missing exp',
      );
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      expSeconds * 1000,
      isUtc: true,
    );
    final now = DateTime.now().toUtc();

    if (!expiresAt.isAfter(now.add(_tokenExpiryLeeway))) {
      debugPrint(
        '[AuthInterceptor] $label token expired at ${expiresAt.toIso8601String()}',
      );
      return const _TokenInspectionResult(isValid: false, reason: 'expired');
    }

    return const _TokenInspectionResult(isValid: true, reason: 'valid');
  }

  Map<String, dynamic>? _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }

    try {
      final normalized = base64.normalize(parts[1]);
      final payloadJson = utf8.decode(base64Url.decode(normalized));
      final payload = json.decode(payloadJson);
      return payload is Map<String, dynamic>
          ? payload
          : Map<String, dynamic>.from(payload as Map);
    } catch (_) {
      return null;
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
      '[AuthInterceptor] Error: ${err.response?.statusCode} - ${err.message}',
    );
    debugPrint('[AuthInterceptor] Error Response: ${err.response?.data}');

    final isAuthRequest =
        err.requestOptions.path == ApiConstants.tokenRefresh ||
        err.requestOptions.path.endsWith(ApiConstants.tokenRefresh) ||
        err.requestOptions.path == ApiConstants.logout ||
        err.requestOptions.path.endsWith(ApiConstants.logout);

    if (_isTokenError(err) && !_isRefreshing && !isAuthRequest) {
      debugPrint('[AuthInterceptor] Token error detected, attempting refresh');
      final refreshToken = await _tokenStorage.getRefreshToken();
      debugPrint(
        '[AuthInterceptor] Refresh token exists: ${refreshToken != null}',
      );

      if (refreshToken == null) {
        debugPrint('[AuthInterceptor] No refresh token, forcing logout');
        await _forceLogout();
        return handler.next(err);
      }

      final refreshed = await _refreshSession(refreshToken: refreshToken);
      if (!refreshed) {
        return handler.next(_buildSessionExpiredError(err));
      }

      final newAccessToken = await _tokenStorage.getAccessToken();
      if (newAccessToken == null || newAccessToken.isEmpty) {
        debugPrint(
          '[AuthInterceptor] Refresh succeeded but no access token was stored',
        );
        await _forceLogout();
        return handler.next(_buildSessionExpiredError(err));
      }

      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccessToken';

      try {
        final retryResponse = await _dio.fetch(options);
        return handler.resolve(retryResponse);
      } catch (retryError) {
        debugPrint('[AuthInterceptor] Retry request failed: $retryError');
        if (retryError is DioException) {
          return handler.next(retryError);
        }
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  /// Clear tokens and notify auth provider to force logout.
  Future<void> _forceLogout() async {
    await _tokenStorage.clearTokens();
    debugPrint('[AuthInterceptor] Tokens cleared; forcing logout');
    _apiClient.onTokenRefreshFailed?.call();
  }

  /// Build a DioException wrapping a TokenRefreshException with a
  /// user-friendly message.
  DioException _buildSessionExpiredError(
    DioException original, {
    dynamic exception,
  }) {
    String errorMessage = 'Session expired. Please login again.';
    if (exception is DioException && exception.response?.data is Map) {
      final responseData = exception.response!.data as Map;
      errorMessage =
          responseData['detail']?.toString() ??
          responseData['message']?.toString() ??
          responseData['error']?.toString() ??
          errorMessage;
    }
    return DioException(
      requestOptions: original.requestOptions,
      error: TokenRefreshException(errorMessage),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: original.requestOptions,
        statusCode: 401,
        data: {'detail': errorMessage},
      ),
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  factory ApiException.fromDioException(DioException e) {
    String message = 'An error occurred';
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (e.response?.data is Map) {
      final responseData = e.response!.data as Map;
      if (responseData.containsKey('detail')) {
        message = responseData['detail'].toString();
      } else if (responseData.containsKey('message')) {
        message = responseData['message'].toString();
      } else if (responseData.containsKey('error')) {
        message = responseData['error'].toString();
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timed out';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = 'Server took too long to respond';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    }

    return ApiException(message: message, statusCode: statusCode, data: data);
  }

  @override
  String toString() => message;
}

class TokenRefreshException implements Exception {
  final String message;

  TokenRefreshException(this.message);

  @override
  String toString() => 'TokenRefreshException: $message';
}

class _TokenInspectionResult {
  final bool isValid;
  final String reason;

  const _TokenInspectionResult({required this.isValid, required this.reason});
}
