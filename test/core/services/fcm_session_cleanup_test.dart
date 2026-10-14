import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/services/fcm_service.dart';

class Settings implements NotificationSettings {
  @override
  AuthorizationStatus get authorizationStatus => AuthorizationStatus.authorized;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class Messaging implements FirebaseMessaging {
  final events = <String>[];
  Completer<void>? deletion;
  Completer<NotificationSettings>? permission;
  bool failDisable = false;
  @override
  Future<NotificationSettings> getNotificationSettings() async =>
      permission == null ? Settings() : permission!.future;
  @override
  Future<void> setAutoInitEnabled(bool enabled) async {
    events.add('auto:$enabled');
    if (!enabled && failDisable) throw StateError('SDK unavailable');
  }

  @override
  Future<void> deleteToken() async {
    events.add('delete start');
    await deletion?.future;
    events.add('delete done');
  }

  @override
  Future<String?> getToken({String? vapidKey, String? serviceWorkerScriptPath}) async {
    events.add('getToken');
    return 'new-token';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('new token generation waits for actual old SDK deletion', () async {
    final sdk = Messaging()..deletion = Completer<void>();
    final service = FcmService.forTesting(messaging: sdk);
    service.startPushForSignedInUser();
    final stop = service.stopPushForSignedOutUser();
    await Future<void>.delayed(Duration.zero);
    service.startPushForSignedInUser();
    final next = service.getToken();
    await Future<void>.delayed(Duration.zero);
    expect(sdk.events, ['auto:false', 'delete start']);
    sdk.deletion!.complete();
    await stop;
    expect(await next, 'new-token');
    expect(
      sdk.events.indexOf('getToken'),
      greaterThan(sdk.events.indexOf('delete done')),
    );
  });
  test('failed auto-init disable still attempts token deletion', () async {
    final sdk = Messaging()..failDisable = true;
    final service = FcmService.forTesting(messaging: sdk);
    await service.stopPushForSignedOutUser();
    expect(sdk.events, contains('delete done'));
  });
  test(
    'permission lookup finishing after logout cannot enable auto-init',
    () async {
      final sdk = Messaging()..permission = Completer<NotificationSettings>();
      final service = FcmService.forTesting(messaging: sdk);
      service.startPushForSignedInUser();
      final token = service.getToken();
      await Future<void>.delayed(Duration.zero);
      final stop = service.stopPushForSignedOutUser();
      sdk.permission!.complete(Settings());
      expect(await token, isNull);
      await stop;
      expect(sdk.events, isNot(contains('auto:true')));
      expect(sdk.events, isNot(contains('getToken')));
    },
  );
}
