import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/providers/notification_provider.dart';
import 'package:teybatdriver/core/services/fcm_service.dart';
import 'package:teybatdriver/core/services/notification_service.dart';
import 'package:teybatdriver/core/models/notification_model.dart';
import 'package:teybatdriver/core/api/api_client.dart';

class FakeFcm implements FcmService {
  final refresh = StreamController<String>.broadcast(sync: true);
  String? token = 'test-device-token';
  int stops = 0;
  Completer<void>? pendingStop;
  @override
  void startPushForSignedInUser() {}
  @override
  void pausePushForSignedOutUser() {}
  @override
  Future<String?> getToken() async => token;
  @override
  StreamSubscription<String> onTokenRefresh(void Function(String) callback) =>
      refresh.stream.listen(callback);
  @override
  Future<void> stopPushForSignedOutUser() async {
    stops++;
    await pendingStop?.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeNotifications implements NotificationService {
  final tokens = <String>[];
  final removedTokens = <String>[];
  Completer<void>? pendingRegistration;
  bool rejectUnregister = false;
  bool rejectRead = false;
  final readIds = <int>[];
  @override
  Future<void> markAsRead(int id) async {
    readIds.add(id);
    if (rejectRead) throw ApiException(message: 'Offline');
  }

  @override
  Future<List<NotificationModel>> getNotifications() => inbox.future;
  final inbox = Completer<List<NotificationModel>>();
  @override
  Future<void> unregisterDeviceToken(String token) async {
    removedTokens.add(token);
    if (rejectUnregister) {
      throw ApiException(message: 'Replaced', statusCode: 401);
    }
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
  NotificationModel unread(int id) => NotificationModel(
    id: id,
    title: 'Test',
    body: 'Test',
    isRead: false,
    createdAt: DateTime.now(),
  );
  test(
    'read count persists remotely and failed writes restore unread count',
    () async {
      final api = FakeNotifications();
      final fcm = FakeFcm();
      final provider = NotificationProvider(
        notificationService: api,
        fcmService: fcm,
      );
      api.inbox.complete([unread(1), unread(2)]);
      await provider.fetchNotifications();
      await provider.markAsRead(1);
      expect(api.readIds, [1]);
      expect(provider.unreadCount, 1);
      api.rejectRead = true;
      await provider.markAsRead(2);
      expect(provider.unreadCount, 1);
      expect(provider.notifications.last.isRead, false);
      provider.dispose();
      await fcm.refresh.close();
    },
  );

  test(
    'clearing the inbox does not pause authenticated push registration',
    () async {
      final api = FakeNotifications();
      final fcm = FakeFcm();
      final provider = NotificationProvider(
        notificationService: api,
        fcmService: fcm,
      );
      api.inbox.complete([unread(1)]);
      await provider.initializePushNotifications();
      await provider.fetchNotifications();
      provider.clearInbox();
      expect(provider.unreadCount, 0);
      fcm.refresh.add('rotated-after-inbox-clear');
      await Future<void>.delayed(Duration.zero);
      expect(api.tokens.last, 'rotated-after-inbox-clear');
      await provider.fetchNotifications(silent: true);
      expect(provider.unreadCount, 0);
      provider.dispose();
      await fcm.refresh.close();
    },
  );

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

  test(
    'rejected unregister still awaits SDK cleanup before new token retrieval',
    () async {
      final fcm = FakeFcm()..pendingStop = Completer<void>();
      final api = FakeNotifications()..rejectUnregister = true;
      final provider = NotificationProvider(
        fcmService: fcm,
        notificationService: api,
      );
      await provider.initializePushNotifications();
      final cleanup = provider.stopPushNotifications();
      await Future<void>.delayed(Duration.zero);
      final nextLogin = provider.initializePushNotifications();
      await Future<void>.delayed(Duration.zero);
      expect(fcm.stops, 1);
      expect(api.tokens.length, 1);
      fcm.pendingStop!.complete();
      await cleanup;
      await nextLogin;
      expect(api.tokens.length, 2);
      provider.dispose();
      await fcm.refresh.close();
    },
  );

  test(
    'late inbox response cannot restore notifications after logout',
    () async {
      final fcm = FakeFcm();
      final api = FakeNotifications();
      final provider = NotificationProvider(
        fcmService: fcm,
        notificationService: api,
      );
      final load = provider.fetchNotifications();
      provider.clearAll();
      api.inbox.complete([
        NotificationModel.fromJson({
          'id': 1,
          'title': 'Old account',
          'body': 'Old message',
          'created_at': '2026-10-14T00:00:00Z',
        }),
      ]);
      await load;
      expect(provider.notifications, isEmpty);
      expect(provider.isLoading, false);
      provider.dispose();
      await fcm.refresh.close();
    },
  );

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
