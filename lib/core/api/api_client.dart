import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';
import 'token_storage.dart';
import 'session_lifecycle.dart';

class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;
  late final _AuthInterceptor _authInterceptor;

  /// Callback invoked when token refresh fails and tokens are cleared.
  /// Use this to trigger logout in your auth provider.
  set onTokenRefreshFailed(Future<void> Function()? callback) {
    session.onRejected = callback;
  }

  final SessionLifecycle session;
  final Dio _refreshDio;

  ApiClient({
    TokenStorage? tokenStorage,
    SessionLifecycle? session,
    Dio? refreshDio,
  }) : session = session ?? SessionLifecycle.shared,
       _refreshDio =
           refreshDio ??
           Dio(
             BaseOptions(
               baseUrl: ApiConstants.baseUrl,
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 15),
               sendTimeout: const Duration(seconds: 15),
             ),
           ),
       _tokenStorage = tokenStorage ?? TokenStorage() {
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
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  Dio get dio => _dio;
  TokenStorage get tokenStorage => _tokenStorage;

  Future<bool> hasValidSession() {
    return _authInterceptor.validateStoredSession();
  }

  Options _sessionOptions(Options? options) => (options ?? Options()).copyWith(
    extra: {...?options?.extra, 'sessionGeneration': session.generation},
  );

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: _sessionOptions(options),
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
      options: _sessionOptions(options),
    );
  }

  Future<Response<T>> patch<T>(String path, {dynamic data, Options? options}) {
    return _dio.patch<T>(path, data: data, options: _sessionOptions(options));
  }

  Future<Response<T>> delete<T>(String path, {dynamic data, Options? options}) {
    return _dio.delete<T>(path, data: data, options: _sessionOptions(options));
  }
}

class _AuthInterceptor extends QueuedInterceptor {
  static const Duration _tokenExpiryLeeway = Duration(seconds: 30);
  static const _publicEndpoints = [
    ApiConstants.publicConfig,
    ApiConstants.passwordLogin,
    ApiConstants.otpRequest,
    ApiConstants.otpVerify,
    ApiConstants.tokenRefresh,
  ];

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final ApiClient _apiClient;

  _AuthInterceptor(this._dio, this._tokenStorage, this._apiClient);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final generation =
        options.extra['sessionGeneration'] as int? ??
        _apiClient.session.generation;
    options.extra['sessionGeneration'] = generation;
    final cleanup = options.extra['sessionCleanup'] == true;
    if (generation != _apiClient.session.generation ||
        (_apiClient.session.signingOut && !cleanup)) {
      return handler.reject(_staleRequest(options));
    }
    // Skip auth header for public endpoints.
    final isPublic = _isPublicEndpoint(options.path);
    debugPrint('[AuthInterceptor] Request: ${options.path}');
    debugPrint('[AuthInterceptor] Is public endpoint: $isPublic');

    if (!isPublic) {
      String? token;
      try {
        token = cleanup
            ? await _tokenStorage.getAccessToken()
            : await _getUsableAccessToken();
      } catch (error) {
        return handler.reject(
          DioException(
            requestOptions: options,
            type: error is DioException ? error.type : DioExceptionType.unknown,
            error: error,
          ),
        );
      }
      if (generation != _apiClient.session.generation || token == null) {
        return handler.reject(_staleRequest(options));
      }
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  DioException _staleRequest(RequestOptions options) => DioException(
    requestOptions: options,
    type: DioExceptionType.cancel,
    error: 'Request belongs to a previous login.',
  );

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.extra['sessionGeneration'] !=
            _apiClient.session.generation ||
        (_apiClient.session.signingOut &&
            response.requestOptions.extra['sessionCleanup'] != true)) {
      return handler.reject(_staleRequest(response.requestOptions));
    }
    handler.next(response);
  }

  bool _isPublicEndpoint(String path) => _publicEndpoints.any(
    (endpoint) => path == endpoint || path.endsWith(endpoint),
  );

  Future<bool> validateStoredSession() async {
    final generation = _apiClient.session.generation;
    await _apiClient.session.waitForWrites();
    final accessToken = await _tokenStorage.getAccessToken();
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (!_apiClient.session.isCurrent(generation)) return false;

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
      await _forceLogout(generation: generation);
      return false;
    }

    debugPrint(
      '[AuthInterceptor] Access token is ${accessState.reason}; attempting refresh with stored refresh token',
    );
    return _refreshSession(refreshToken: refreshToken!, generation: generation);
  }

  /// Check if the error response indicates a token/auth problem.
  bool _isTokenError(DioException err) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
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
    final generation = _apiClient.session.generation;
    await _apiClient.session.waitForWrites();
    final accessToken = await _tokenStorage.getAccessToken();
    final accessState = _inspectToken(accessToken, label: 'access');
    if (!_apiClient.session.isCurrent(generation)) return null;

    if (accessState.isValid) {
      return accessToken;
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    final refreshState = _inspectToken(refreshToken, label: 'refresh');
    if (!_apiClient.session.isCurrent(generation)) return null;

    if (!refreshState.isValid) {
      if ((accessToken != null && accessToken.isNotEmpty) ||
          (refreshToken != null && refreshToken.isNotEmpty)) {
        debugPrint(
          '[AuthInterceptor] No usable refresh token available (${refreshState.reason}); forcing logout',
        );
        await _forceLogout(generation: generation);
      }
      return null;
    }

    debugPrint(
      '[AuthInterceptor] Access token is ${accessState.reason}; refreshing before request',
    );
    final refreshed = await _refreshSession(
      refreshToken: refreshToken!,
      generation: generation,
    );
    if (!refreshed) {
      return null;
    }

    return _tokenStorage.getAccessToken();
  }

  Future<bool> _refreshSession({
    required String refreshToken,
    required int generation,
  }) async {
    if (!_apiClient.session.isCurrent(generation)) return false;
    final session = _apiClient.session;
    if (session.refresh != null && session.refreshGeneration == generation) {
      return session.refresh!;
    }
    session.refreshGeneration = generation;
    final task = _performRefresh(refreshToken, generation);
    session.refresh = task;
    try {
      return await task;
    } finally {
      if (identical(session.refresh, task)) {
        session.refresh = null;
        session.refreshGeneration = null;
      }
    }
  }

  Future<bool> _performRefresh(String refreshToken, int generation) async {
    try {
      final response = await _apiClient._refreshDio.post(
        ApiConstants.tokenRefresh,
        data: {'refresh': refreshToken},
      );
      if (!_apiClient.session.isCurrent(generation)) return false;

      debugPrint('[AuthInterceptor] Refresh response: ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint(
          '[AuthInterceptor] Refresh returned ${response.statusCode}, forcing logout',
        );
        await _forceLogout(generation: generation);
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
        await _forceLogout(generation: generation);
        return false;
      }

      final saved = await _apiClient.session.writeIfCurrent(
        generation,
        () => _tokenStorage.saveTokens(
          accessToken: newAccessToken!,
          refreshToken: newRefreshToken,
        ),
      );
      if (!saved) return false;
      debugPrint('[AuthInterceptor] New tokens saved');
      return true;
    } catch (e) {
      debugPrint('[AuthInterceptor] Token refresh failed: $e');
      if (!_apiClient.session.isCurrent(generation)) return false;
      if (e is DioException &&
          (e.response?.statusCode == 401 || e.response?.statusCode == 403)) {
        await _forceLogout(generation: generation);
        return false;
      }
      // Offline, timeout and server failures preserve saved credentials.
      rethrow;
    }
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
    final generation = err.requestOptions.extra['sessionGeneration'] as int?;
    if (generation == null ||
        err.requestOptions.extra['sessionGeneration'] !=
            _apiClient.session.generation ||
        err.requestOptions.extra['sessionCleanup'] == true ||
        err.requestOptions.extra['sessionRetried'] == true) {
      return handler.next(err);
    }
    debugPrint(
      '[AuthInterceptor] Error: ${err.response?.statusCode} - ${err.message}',
    );
    debugPrint('[AuthInterceptor] Error Response: ${err.response?.data}');

    final isAuthRequest =
        _isPublicEndpoint(err.requestOptions.path) ||
        err.requestOptions.path == ApiConstants.tokenRefresh ||
        err.requestOptions.path.endsWith(ApiConstants.tokenRefresh) ||
        err.requestOptions.path == ApiConstants.logout ||
        err.requestOptions.path.endsWith(ApiConstants.logout);

    if (_isTokenError(err) && !isAuthRequest) {
      debugPrint('[AuthInterceptor] Token error detected, attempting refresh');
      await _apiClient.session.waitForWrites();
      final refreshToken = await _tokenStorage.getRefreshToken();
      debugPrint(
        '[AuthInterceptor] Refresh token exists: ${refreshToken != null}',
      );

      if (refreshToken == null) {
        debugPrint('[AuthInterceptor] No refresh token, forcing logout');
        await _forceLogout(generation: generation);
        return handler.next(err);
      }

      bool refreshed;
      try {
        refreshed = await _refreshSession(
          refreshToken: refreshToken,
          generation: generation,
        );
      } on DioException catch (refreshError) {
        return handler.next(refreshError);
      } catch (_) {
        return handler.next(err);
      }
      if (!refreshed) {
        return handler.next(_buildSessionExpiredError(err));
      }

      final newAccessToken = await _tokenStorage.getAccessToken();
      if (newAccessToken == null || newAccessToken.isEmpty) {
        debugPrint(
          '[AuthInterceptor] Refresh succeeded but no access token was stored',
        );
        await _forceLogout(generation: generation);
        return handler.next(_buildSessionExpiredError(err));
      }

      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccessToken';
      options.extra['sessionRetried'] = true;

      try {
        if (!_apiClient.session.isCurrent(generation)) {
          return handler.next(_staleRequest(options));
        }
        // Re-entering this QueuedInterceptor while its error handler awaits a
        // retry can deadlock on a second error. Retry once without interceptors.
        final retryClient = Dio()..httpClientAdapter = _dio.httpClientAdapter;
        final retryResponse = await retryClient.fetch(options);
        if (!_apiClient.session.isCurrent(generation)) {
          return handler.next(_staleRequest(options));
        }
        return handler.resolve(retryResponse);
      } catch (retryError) {
        debugPrint('[AuthInterceptor] Retry request failed: $retryError');
        if (retryError is DioException) {
          if (retryError.response?.statusCode == 401) {
            await _forceLogout(generation: generation);
          }
          return handler.next(retryError);
        }
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  /// Clear tokens and notify auth provider to force logout.
  Future<void> _forceLogout({int? generation}) async {
    if (generation != null && !_apiClient.session.isCurrent(generation)) return;
    final callback = _apiClient.session.onRejected;
    if (callback != null) {
      await callback();
    } else {
      final epoch = _apiClient.session.beginLogout();
      await _apiClient.session.writeIfCurrent(epoch, _tokenStorage.clearTokens);
    }
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
