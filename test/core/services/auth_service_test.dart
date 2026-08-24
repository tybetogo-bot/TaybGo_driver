import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/api/api_client.dart';
import 'package:teybatdriver/core/api/token_storage.dart';
import 'package:teybatdriver/core/config/app_config.dart';
import 'package:teybatdriver/core/services/auth_service.dart';

void main() {
  setUpAll(() {
    AppConfig.init(env: Environment.dev);
  });

  group('AuthService OTP payloads', () {
    test('password login posts phone and password and saves tokens', () async {
      final tokenStorage = _InMemoryTokenStorage();
      final apiClient = _RecordingApiClient(
        tokenStorage: tokenStorage,
        nextResponse: (path, data) => Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
          data: {'access': 'access-token', 'refresh': 'refresh-token'},
        ),
      );
      final service = AuthService(apiClient: apiClient);

      await service.loginWithPassword(
        phoneNumber: '+49123456789',
        password: 'secret-password',
      );

      expect(apiClient.posts.single.path, '/auth/token/');
      expect(apiClient.posts.single.data, {
        'phone': '+49123456789',
        'password': 'secret-password',
      });
      expect(tokenStorage.savedAccessToken, 'access-token');
      expect(tokenStorage.savedRefreshToken, 'refresh-token');
    });

    test('requestOtp includes target_role', () async {
      final apiClient = _RecordingApiClient(
        tokenStorage: _InMemoryTokenStorage(),
        nextResponse: (path, data) => Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
          data: {'message': 'OTP sent successfully'},
        ),
      );
      final service = AuthService(apiClient: apiClient);

      await service.requestOtp(
        phoneNumber: '+49123456789',
        targetRole: 'driver',
      );

      expect(apiClient.posts, hasLength(1));
      expect(apiClient.posts.single.path, '/auth/otp/request/');
      expect(apiClient.posts.single.data, {
        'phone': '+49123456789',
        'target_role': 'driver',
      });
    });

    test('verifyOtp includes target_role', () async {
      final tokenStorage = _InMemoryTokenStorage();
      final apiClient = _RecordingApiClient(
        tokenStorage: tokenStorage,
        nextResponse: (path, data) => Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
          data: {
            'access': 'access-token',
            'refresh': 'refresh-token',
            'is_new_user': false,
          },
        ),
      );
      final service = AuthService(apiClient: apiClient);

      await service.verifyOtp(
        phoneNumber: '+49123456789',
        otp: '123456',
        targetRole: 'driver',
      );

      expect(apiClient.posts, hasLength(1));
      expect(apiClient.posts.single.path, '/auth/otp/verify/');
      expect(apiClient.posts.single.data, {
        'phone': '+49123456789',
        'code': '123456',
        'target_role': 'driver',
      });
      expect(tokenStorage.savedAccessToken, 'access-token');
      expect(tokenStorage.savedRefreshToken, 'refresh-token');
    });
  });
}

class _RecordingApiClient extends ApiClient {
  _RecordingApiClient({
    required this.nextResponse,
    required TokenStorage tokenStorage,
  }) : super(tokenStorage: tokenStorage);

  final Response<dynamic> Function(String path, dynamic data) nextResponse;
  final List<_RecordedPost> posts = [];

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    posts.add(_RecordedPost(path: path, data: data));
    return nextResponse(path, data) as Response<T>;
  }
}

class _RecordedPost {
  const _RecordedPost({required this.path, required this.data});

  final String path;
  final dynamic data;
}

class _InMemoryTokenStorage extends TokenStorage {
  String? savedAccessToken;
  String? savedRefreshToken;

  @override
  Future<String?> getAccessToken() async => savedAccessToken;

  @override
  Future<String?> getRefreshToken() async => savedRefreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    savedAccessToken = accessToken;
    savedRefreshToken = refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    savedAccessToken = null;
    savedRefreshToken = null;
  }
}
