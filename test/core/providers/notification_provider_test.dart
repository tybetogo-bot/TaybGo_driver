import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/providers/notification_provider.dart';
import 'package:teybatdriver/core/services/fcm_service.dart';
import 'package:teybatdriver/core/services/notification_service.dart';

class FakeFcm implements FcmService {
  final refresh = StreamController<String>.broadcast(sync: true);
  String? token = 'test-device-token';
  int stops = 0;
  @override
  Future<String?> getToken() async => token;
  @override
  StreamSubscription<String> onTokenRefresh(void Function(String) callback) =>
      refresh.stream.listen(callback);
  @override
  Future<void> stopPushForSignedOutUser() async {
    stops++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeNotifications implements NotificationService {
  final tokens = <String>[];
  final removedTokens = <String>[];
  Completer<void>? pendingRegistration;
  @override
  Future<void> unregisterDeviceToken(String token) async {
    removedTokens.add(token);
  }

  @override
  Future<void> registerDeviceToken({
    required String token,
    required String deviceType,
  }) async {
    tokens.add(token);
    await pendingRegistration?.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'one refresh listener per session and no registration after logout',
    () async {
      final fcm = FakeFcm();
      final api = FakeNotifications();
      final provider = NotificationProvider(
        fcmService: fcm,
        notificationService: api,
      );
      await provider.initializePushNotifications();
      await provider.initializePushNotifications();
      expect(api.tokens, ['test-device-token']);
      fcm.refresh.add('rotated-token');
      await Future<void>.delayed(Duration.zero);
      expect(api.tokens, ['test-device-token', 'rotated-token']);
      await provider.stopPushNotifications();
      fcm.refresh.add('signed-out-token');
      await Future<void>.delayed(Duration.zero);
      expect(api.tokens.length, 2);
      expect(fcm.stops, 1);
      expect(api.removedTokens, ['rotated-token']);
      await provider.initializePushNotifications();
      expect(api.tokens.length, 3);
      provider.dispose();
      await fcm.refresh.close();
    },
  );

  test('an old registration cannot mark the next session registered', () async {
    final fcm = FakeFcm();
    final api = FakeNotifications()..pendingRegistration = Completer<void>();
    final provider = NotificationProvider(
      fcmService: fcm,
      notificationService: api,
    );
    final initialization = provider.initializePushNotifications();
    await Future<void>.delayed(Duration.zero);
    provider.clearAll();
    api.pendingRegistration!.complete();
    await initialization;
    expect(provider.isTokenRegistered, false);
    provider.dispose();
    await fcm.refresh.close();
  });

  test('token readiness retries stop on logout', () async {
    final fcm = FakeFcm()..token = null;
    final api = FakeNotifications();
    final provider = NotificationProvider(
      fcmService: fcm,
      notificationService: api,
    );
    await provider.initializePushNotifications();
    expect(api.tokens, isEmpty);
    await provider.stopPushNotifications();
    provider.dispose();
    await fcm.refresh.close();
  });
}
