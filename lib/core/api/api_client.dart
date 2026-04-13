import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';
import 'token_storage.dart';

class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;
  late final _AuthInterceptor _authInterceptor;

  /// Callback invoked when token refresh fails and tokens are cleared
  /// Use this to trigger logout in your auth provider
  void Function()? onTokenRefreshFailed;

  ApiClient({TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorage() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _authInterceptor = _AuthInterceptor(_dio, _tokenStorage, this);
    _dio.interceptors.add(_authInterceptor);
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;
  TokenStorage get tokenStorage => _tokenStorage;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) {
    return _dio.patch<T>(path, data: data, options: options);
  }

  Future<Response<T>> delete<T>(
    String path, {
    Options? options,
  }) {
    return _dio.delete<T>(path, options: options);
  }
}

class _AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final TokenStorage _tokenStorage;
  final ApiClient _apiClient;
  bool _isRefreshing = false;

  _AuthInterceptor(this._dio, this._tokenStorage, this._apiClient);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth header for public endpoints
    final publicEndpoints = [
      ApiConstants.otpRequest,
      ApiConstants.otpVerify,
      ApiConstants.tokenRefresh,
    ];

    // Use exact match or endsWith to avoid false positives
    final isPublic = publicEndpoints.any((e) => options.path == e || options.path.endsWith(e));
    debugPrint('[AuthInterceptor] Request: ${options.path}');
    debugPrint('[AuthInterceptor] Is public endpoint: $isPublic');

    if (!isPublic) {
      final token = await _tokenStorage.getAccessToken();
      debugPrint('[AuthInterceptor] Token exists: ${token != null}');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  /// Check if the error response indicates a token/auth problem
  bool _isTokenError(DioException err) {
    final statusCode = err.response?.statusCode;

    // 401 Unauthorized or 403 Forbidden
    if (statusCode == 401 || statusCode == 403) {
      return true;
    }

    // Check response body for token-related error messages
    final data = err.response?.data;
    if (data is Map) {
      final detail = (data['detail'] ?? data['message'] ?? data['code'] ?? '').toString().toLowerCase();
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
      if (tokenErrors.any((e) => detail.contains(e))) {
        return true;
      }
    }

    return false;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('[AuthInterceptor] Error: ${err.response?.statusCode} - ${err.message}');
    debugPrint('[AuthInterceptor] Error Response: ${err.response?.data}');

    // Skip refresh for auth endpoints to avoid infinite loops
    final isAuthRequest = err.requestOptions.path == ApiConstants.tokenRefresh ||
        err.requestOptions.path.endsWith(ApiConstants.tokenRefresh) ||
        err.requestOptions.path == ApiConstants.logout ||
        err.requestOptions.path.endsWith(ApiConstants.logout);

    if (_isTokenError(err) && !_isRefreshing && !isAuthRequest) {
      debugPrint('[AuthInterceptor] Token error detected, attempting refresh...');
      _isRefreshing = true;

      final refreshToken = await _tokenStorage.getRefreshToken();
      debugPrint('[AuthInterceptor] Refresh token exists: ${refreshToken != null}');

      if (refreshToken == null) {
        debugPrint('[AuthInterceptor] No refresh token, forcing logout');
        _isRefreshing = false;
        await _forceLogout();
        return handler.next(err);
      }

      try {
        // Try to refresh the token using a separate Dio instance
        final response = await Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {'Content-Type': 'application/json'},
        )).post(
          ApiConstants.tokenRefresh,
          data: {'refresh': refreshToken},
        );

        debugPrint('[AuthInterceptor] Refresh response: ${response.statusCode}');

        if (response.statusCode == 200) {
          final newAccessToken = response.data['access'] as String;
          final newRefreshToken = response.data['refresh'] as String? ?? refreshToken;

          await _tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          debugPrint('[AuthInterceptor] New tokens saved');

          _isRefreshing = false;

          // Retry the original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            final retryResponse = await _dio.fetch(options);
            return handler.resolve(retryResponse);
          } catch (retryError) {
            debugPrint('[AuthInterceptor] Retry request failed: $retryError');
            _isRefreshing = false;
            if (retryError is DioException) {
              return handler.next(retryError);
            }
            return handler.next(err);
          }
        } else {
          // Non-200 refresh response — treat as failure
          debugPrint('[AuthInterceptor] Refresh returned ${response.statusCode}, forcing logout');
          _isRefreshing = false;
          await _forceLogout();
          return handler.next(_buildSessionExpiredError(err));
        }
      } catch (e) {
        debugPrint('[AuthInterceptor] Token refresh failed: $e');
        _isRefreshing = false;
        await _forceLogout();
        return handler.next(_buildSessionExpiredError(err, exception: e));
      }
    }

    handler.next(err);
  }

  /// Clear tokens and notify auth provider to force logout
  Future<void> _forceLogout() async {
    await _tokenStorage.clearTokens();
    debugPrint('[AuthInterceptor] Tokens cleared — forcing logout');
    _apiClient.onTokenRefreshFailed?.call();
  }

  /// Build a DioException wrapping a TokenRefreshException with a user-friendly message
  DioException _buildSessionExpiredError(DioException original, {dynamic exception}) {
    String errorMessage = 'Session expired. Please login again.';
    if (exception is DioException && exception.response?.data is Map) {
      final responseData = exception.response!.data as Map;
      errorMessage = responseData['detail']?.toString() ??
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

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioException(DioException e) {
    String message = 'An error occurred';
    int? statusCode = e.response?.statusCode;
    dynamic data = e.response?.data;

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

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: data,
    );
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
