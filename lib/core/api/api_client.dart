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

class _AuthInterceptor extends Interceptor {
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
    ];

    // Use exact match or endsWith to avoid false positives
    final isPublic = publicEndpoints.any((e) => options.path == e || options.path.endsWith(e));
    debugPrint('[AuthInterceptor] Request: ${options.path}');
    debugPrint('[AuthInterceptor] Is public endpoint: $isPublic');

    if (!isPublic) {
      final token = await _tokenStorage.getAccessToken();
      debugPrint('[AuthInterceptor] Token exists: ${token != null}');
      debugPrint('[AuthInterceptor] Token (first 20 chars): ${token?.substring(0, token.length > 20 ? 20 : token.length)}...');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('[AuthInterceptor] Error: ${err.response?.statusCode} - ${err.message}');
    debugPrint('[AuthInterceptor] Error Response: ${err.response?.data}');

    if (err.response?.statusCode == 401 && !_isRefreshing) {
      debugPrint('[AuthInterceptor] Attempting token refresh...');
      _isRefreshing = true;

      final refreshToken = await _tokenStorage.getRefreshToken();
      debugPrint('[AuthInterceptor] Refresh token exists: ${refreshToken != null}');

      if (refreshToken == null) {
        debugPrint('[AuthInterceptor] No refresh token, cannot refresh');
        _isRefreshing = false;
        return handler.next(err);
      }

      try {
        // Try to refresh the token
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

          // Retry the original request
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            final retryResponse = await _dio.fetch(options);
            _isRefreshing = false;
            return handler.resolve(retryResponse);
          } catch (retryError) {
            debugPrint('[AuthInterceptor] Retry request failed: $retryError');
            _isRefreshing = false;
            // Return the retry error, not the original 401
            if (retryError is DioException) {
              return handler.next(retryError);
            }
            return handler.next(err);
          }
        }
      } catch (e) {
        debugPrint('[AuthInterceptor] Token refresh failed: $e');

        // Clear tokens when refresh fails
        await _tokenStorage.clearTokens();
        debugPrint('[AuthInterceptor] Tokens cleared due to refresh failure');

        // Notify the auth provider to handle logout
        _apiClient.onTokenRefreshFailed?.call();
        debugPrint('[AuthInterceptor] Token refresh failure callback invoked');

        _isRefreshing = false;

        // Extract error message from the refresh failure
        String errorMessage = 'Session expired. Please login again.';
        if (e is DioException && e.response?.data is Map) {
          final responseData = e.response!.data as Map;
          errorMessage = responseData['detail']?.toString() ??
                        responseData['message']?.toString() ??
                        responseData['error']?.toString() ??
                        errorMessage;
        }

        // Return a TokenRefreshException wrapped in DioException
        final tokenRefreshError = DioException(
          requestOptions: err.requestOptions,
          error: TokenRefreshException(errorMessage),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: err.requestOptions,
            statusCode: 401,
            data: {'detail': errorMessage},
          ),
        );

        return handler.next(tokenRefreshError);
      }
    }

    handler.next(err);
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
