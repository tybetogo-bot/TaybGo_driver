import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teybatdriver/core/services/location_service.dart';

class LocationPlatform extends GeolocatorPlatform {
  Completer<Position>? pendingPosition;
  final position = Position.fromMap({
    'latitude': 1.0,
    'longitude': 2.0,
    'timestamp': 1,
    'accuracy': 1.0,
    'altitude': 0.0,
    'altitude_accuracy': 0.0,
    'heading': 0.0,
    'heading_accuracy': 0.0,
    'speed': 0.0,
    'speed_accuracy': 0.0,
  });
  @override
  Future<bool> isLocationServiceEnabled() async => true;
  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.always;
  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async => pendingPosition == null ? position : pendingPosition!.future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late GeolocatorPlatform original;
  late LocationPlatform platform;
  setUp(() {
    original = GeolocatorPlatform.instance;
    platform = LocationPlatform();
    GeolocatorPlatform.instance = platform;
    LocationService().stopLocationUpdates();
  });
  tearDown(() {
    GeolocatorPlatform.instance = original;
  });
  test('logout clears the singleton last location cache', () async {
    final service = LocationService();
    expect((await service.getCurrentLocation()).success, true);
    expect(service.lastPosition, isNotNull);
    service.stopLocationUpdates();
    expect(service.lastPosition, isNull);
  });
  test('late location lookup cannot restore the cache after logout', () async {
    final service = LocationService();
    platform.pendingPosition = Completer<Position>();
    final lookup = service.getCurrentLocation();
    await Future<void>.delayed(Duration.zero);
    service.stopLocationUpdates();
    platform.pendingPosition!.complete(platform.position);
    expect((await lookup).success, false);
    expect(service.lastPosition, isNull);
  });
}
