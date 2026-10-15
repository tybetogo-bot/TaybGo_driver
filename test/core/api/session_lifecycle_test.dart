import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teybatdriver/core/api/api_client.dart';
import 'package:teybatdriver/core/api/session_lifecycle.dart';
import 'package:teybatdriver/core/api/token_storage.dart';
import 'package:teybatdriver/core/config/app_config.dart';
import 'package:teybatdriver/core/providers/auth_provider.dart';
import 'package:teybatdriver/core/services/auth_service.dart';

String jwt(String sid, {bool expired = false}) =>
    'header.${base64Url.encode(utf8.encode(jsonEncode({'sid': sid, 'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 + (expired ? -60 : 3600)})))}.signature';

class MemoryTokens extends TokenStorage {
  String? access = jwt('old', expired: true);
  String? refresh = jwt('old');
  @override
  Future<String?> getAccessToken() async => access;
  @override
  Future<String?> getRefreshToken() async => refresh;
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    access = accessToken;
    refresh = refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    access = null;
    refresh = null;
  }
}

class Adapter implements HttpClientAdapter {
  Adapter(this.respond);
  final Future<ResponseBody> Function(RequestOptions) respond;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => respond(options);
  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(Object data, [int status = 200]) =>
    ResponseBody.fromString(
      jsonEncode(data),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AppConfig.init(env: Environment.prod);
  });

  test(
    'offline refresh preserves credentials and does not force cleanup',
    () async {
      final tokens = MemoryTokens();
      final session = SessionLifecycle();
      var rejected = false;
      session.onRejected = () async {
        rejected = true;
      };
      final refresh = Dio()
        ..httpClientAdapter = Adapter((options) async {
          throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          );
        });
      final client = ApiClient(
        tokenStorage: tokens,
        session: session,
        refreshDio: refresh,
      );
      await expectLater(client.hasValidSession(), throwsA(isA<DioException>()));
      expect(tokens.refresh, isNotNull);
      expect(rejected, false);
    },
  );

  test('late refresh success cannot overwrite a different login', () async {
    final tokens = MemoryTokens();
    final session = SessionLifecycle();
    final pending = Completer<ResponseBody>();
    final started = Completer<void>();
    final refresh = Dio()
      ..httpClientAdapter = Adapter((_) {
        started.complete();
        return pending.future;
      });
    final client = ApiClient(
      tokenStorage: tokens,
      session: session,
      refreshDio: refresh,
    );
    final result = client.hasValidSession();
    await started.future;
    session.beginLogout();
    await session.beginLogin();
    await session.writeIfCurrent(
      session.generation,
      () =>
          tokens.saveTokens(accessToken: jwt('new'), refreshToken: jwt('new')),
    );
    pending.complete(
      jsonResponse({'access': jwt('old'), 'refresh': jwt('old')}),
    );
    expect(await result, false);
    expect(tokens.access, jwt('new'));
  });

  test('late refresh rejection cannot clear a different login', () async {
    final tokens = MemoryTokens();
    final session = SessionLifecycle();
    var rejected = false;
    session.onRejected = () async {
      rejected = true;
    };
    final pending = Completer<ResponseBody>();
    final started = Completer<void>();
    final refresh = Dio()
      ..httpClientAdapter = Adapter((_) {
        started.complete();
        return pending.future;
      });
    final client = ApiClient(
      tokenStorage: tokens,
      session: session,
      refreshDio: refresh,
    );
    final result = client.hasValidSession();
    await started.future;
    await session.beginLogin();
    tokens.access = jwt('new');
    tokens.refresh = jwt('new');
    pending.complete(jsonResponse({'code': 'session_replaced'}, 401));
    expect(await result, false);
    expect(rejected, false);
    expect(tokens.refresh, jwt('new'));
  });

  test(
    'feature clients share one refresh and retain rotated refresh token',
    () async {
      final tokens = MemoryTokens();
      final session = SessionLifecycle();
      final pending = Completer<ResponseBody>();
      final started = Completer<void>();
      var calls = 0;
      final refresh = Dio()
        ..httpClientAdapter = Adapter((_) {
          calls++;
          started.complete();
          return pending.future;
        });
      final a = ApiClient(
        tokenStorage: tokens,
        session: session,
        refreshDio: refresh,
      );
      final b = ApiClient(
        tokenStorage: tokens,
        session: session,
        refreshDio: refresh,
      );
      final first = a.hasValidSession();
      await started.future;
      final second = b.hasValidSession();
      await Future<void>.delayed(Duration.zero);
      pending.complete(
        jsonResponse({'access': jwt('old'), 'refresh': jwt('rotated')}),
      );
      expect(await first, true);
      expect(await second, true);
      expect(calls, 1);
      expect(tokens.refresh, jwt('rotated'));
    },
  );

  test(
    'replaced access refreshes once then completes forced cleanup on rejection',
    () async {
      final tokens = MemoryTokens()..access = jwt('old');
      final session = SessionLifecycle();
      var refreshCalls = 0;
      final refresh = Dio()
        ..httpClientAdapter = Adapter((_) async {
          refreshCalls++;
          return jsonResponse({'code': 'session_replaced'}, 401);
        });
      final client = ApiClient(
        tokenStorage: tokens,
        session: session,
        refreshDio: refresh,
      );
      final auth = AuthProvider(authService: AuthService(apiClient: client));
      var cleanups = 0;
      auth.onLogoutCallback = () async {
        cleanups++;
      };
      await auth.initialize();
      client.dio.httpClientAdapter = Adapter(
        (_) async => jsonResponse({'code': 'session_replaced'}, 401),
      );
      await expectLater(
        client.get('/me/').timeout(const Duration(seconds: 2)),
        throwsA(isA<DioException>()),
      );
      expect(refreshCalls, 1);
      expect(cleanups, 1);
      expect(tokens.access, isNull);
      expect(auth.isAuthenticated, false);
      auth.dispose();
    },
  );

  test(
    'a second 401 after refresh cannot deadlock or refresh repeatedly',
    () async {
      final tokens = MemoryTokens()..access = jwt('old');
      final session = SessionLifecycle();
      var refreshCalls = 0;
      final refresh = Dio()
        ..httpClientAdapter = Adapter((_) async {
          refreshCalls++;
          return jsonResponse({'access': jwt('old'), 'refresh': jwt('old')});
        });
      final client = ApiClient(
        tokenStorage: tokens,
        session: session,
        refreshDio: refresh,
      );
      client.dio.httpClientAdapter = Adapter(
        (_) async => jsonResponse({'code': 'session_replaced'}, 401),
      );
      await expectLater(
        client.get('/me/').timeout(const Duration(seconds: 2)),
        throwsA(isA<DioException>()),
      );
      expect(refreshCalls, 1);
      expect(tokens.access, isNull);
    },
  );

  test('late API responses and errors cannot affect the next login', () async {
    final tokens = MemoryTokens()..access = jwt('old');
    final session = SessionLifecycle();
    final pending = Completer<ResponseBody>();
    final started = Completer<void>();
    final client = ApiClient(tokenStorage: tokens, session: session);
    client.dio.httpClientAdapter = Adapter((_) {
      started.complete();
      return pending.future;
    });
    final response = client.get('/notifications');
    final assertion = expectLater(response, throwsA(isA<DioException>()));
    await started.future;
    await session.beginLogin();
    pending.complete(
      jsonResponse([
        {'title': 'old account'},
      ]),
    );
    await assertion;
  });

  for (final forced in [false, true]) {
    test(
      '${forced ? 'forced' : 'manual'} logout waits for local cleanup before re-login',
      () async {
        final tokens = MemoryTokens()..access = jwt('old');
        final session = SessionLifecycle();
        final client = ApiClient(tokenStorage: tokens, session: session);
        final requests = <String>[];
        client.dio.httpClientAdapter = Adapter((options) async {
          requests.add(options.path);
          if (options.path == '/auth/token/') {
            return jsonResponse({'access': jwt('new'), 'refresh': jwt('new')});
          }
          return jsonResponse({'detail': 'Logged out'});
        });
        final auth = AuthProvider(authService: AuthService(apiClient: client));
        await auth.initialize();
        final localCleanup = Completer<void>();
        auth.onLogoutCallback = () => localCleanup.future;
        final logout = auth.logout(forced: forced);
        expect(auth.isAuthenticated, false);
        final login = auth.loginWithPassword('+15550000000', 'test-password');
        await Future<void>.delayed(Duration.zero);
        expect(requests, isNot(contains('/auth/token/')));
        if (forced) expect(requests, isEmpty);
        localCleanup.complete();
        await logout;
        expect(await login, true);
        expect(tokens.refresh, jwt('new'));
        expect(auth.isAuthenticated, true);
        auth.dispose();
      },
    );
  }

  test('rejected restoration finishes startup in signed-out state', () async {
    final tokens = MemoryTokens();
    final session = SessionLifecycle();
    final refresh = Dio()
      ..httpClientAdapter = Adapter(
        (_) async => jsonResponse({'code': 'session_replaced'}, 401),
      );
    final client = ApiClient(
      tokenStorage: tokens,
      session: session,
      refreshDio: refresh,
    );
    final auth = AuthProvider(authService: AuthService(apiClient: client));
    await auth.initialize();
    expect(auth.initialized, true);
    expect(auth.isAuthenticated, false);
    expect(tokens.refresh, isNull);
    auth.dispose();
  });

  test(
    'credential deletion is serialized before a newer login write',
    () async {
      final session = SessionLifecycle();
      final deleting = Completer<void>();
      final events = <String>[];
      final old = session.writeIfCurrent(session.generation, () async {
        events.add('delete start');
        await deleting.future;
        events.add('delete done');
      });
      await Future<void>.delayed(Duration.zero);
      await session.beginLogin();
      final next = session.writeIfCurrent(session.generation, () async {
        events.add('new tokens');
      });
      await Future<void>.delayed(Duration.zero);
      expect(events, ['delete start']);
      deleting.complete();
      await old;
      await next;
      expect(events, ['delete start', 'delete done', 'new tokens']);
    },
  );
}
