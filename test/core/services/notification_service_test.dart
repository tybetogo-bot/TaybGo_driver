import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teybatdriver/core/api/api_client.dart';
import 'package:teybatdriver/core/services/notification_service.dart';

class RecordingApi implements ApiClient {
  @override
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    this.path = path;
    body = data;
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
    );
  }

  String? path;
  dynamic body;
  @override
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    this.path = path;
    body = data;
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      statusCode: 204,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('mark read uses the authenticated notification detail PATCH', () async {
    final api = RecordingApi();
    await NotificationService(apiClient: api).markAsRead(42);
    expect(api.path, '/notifications/42');
    expect(api.body, {'is_read': true});
  });
  test(
    'logout removes the current device using the backend DELETE contract',
    () async {
      final api = RecordingApi();
      await NotificationService(
        apiClient: api,
      ).unregisterDeviceToken('current-device');
      expect(api.path, '/notifications/device');
      expect(api.body, {'token': 'current-device'});
    },
  );
}
