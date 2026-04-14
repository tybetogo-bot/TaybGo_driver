import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

enum LocationPermissionStatus {
  grantedForegroundOnly,
  grantedAlways,
  denied,
  deniedForever,
  serviceDisabled,
}

extension LocationPermissionStatusX on LocationPermissionStatus {
  bool get hasForegroundAccess =>
      this == LocationPermissionStatus.grantedForegroundOnly ||
      this == LocationPermissionStatus.grantedAlways;

  bool get hasBackgroundAccess =>
      this == LocationPermissionStatus.grantedAlways;
}

class LocationResult {
  final bool success;
  final Position? position;
  final LocationPermissionStatus? status;
  final String? message;

  LocationResult({
    required this.success,
    this.position,
    this.status,
    this.message,
  });
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  static const MethodChannel _permissionChannel = MethodChannel(
    'com.taybgo.driver/location_permissions',
  );

  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;

  Position? get lastPosition => _lastPosition;

  /// Check if location services are enabled and we have permission
  Future<LocationPermissionStatus> checkPermission() async {
    final permission = await Geolocator.checkPermission();
    return _mapPermission(permission);
  }

  /// Request location permission
  Future<LocationPermissionStatus> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    return _mapPermission(permission);
  }

  /// Request background-capable location permission.
  ///
  /// On Android this tries to upgrade from "While in use" to background
  /// location. On iOS this escalates from "When In Use" to "Always".
  Future<LocationPermissionStatus> requestBackgroundPermission() async {
    var status = await checkPermission();

    if (!status.hasForegroundAccess) {
      status = await requestPermission();
      if (!status.hasForegroundAccess) {
        return status;
      }
    }

    if (status.hasBackgroundAccess ||
        kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return status;
    }

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await Geolocator.requestPermission();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _permissionChannel.invokeMethod<String>(
          'requestAlwaysPermission',
        );
      }
    } on PlatformException catch (e) {
      debugPrint(
        '[LocationService] Failed to request background permission: ${e.code} ${e.message}',
      );
    } on MissingPluginException {
      debugPrint(
        '[LocationService] Background permission bridge is unavailable on this platform build.',
      );
    }

    return checkPermission();
  }

  /// Get current location (with permission check)
  Future<LocationResult> getCurrentLocation() async {
    // Check permission first
    final status = await checkPermission();

    if (!status.hasForegroundAccess) {
      // Try to request permission
      final requestStatus = await requestPermission();
      if (!requestStatus.hasForegroundAccess) {
        return LocationResult(
          success: false,
          status: requestStatus,
          message: _getStatusMessage(requestStatus),
        );
      }
    }

    try {
      // On web, use low accuracy for faster response
      // On mobile, use medium accuracy (network + GPS)
      final accuracy = kIsWeb ? LocationAccuracy.low : LocationAccuracy.medium;
      final timeout = kIsWeb
          ? const Duration(seconds: 30)
          : const Duration(seconds: 10);

      debugPrint(
        'Getting location with accuracy: $accuracy, timeout: $timeout, isWeb: $kIsWeb',
      );

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeout,
      );

      _lastPosition = position;
      debugPrint('Got location: ${position.latitude}, ${position.longitude}');

      return LocationResult(
        success: true,
        position: position,
        status: await checkPermission(),
      );
    } on TimeoutException {
      debugPrint('Location timeout');
      // getLastKnownPosition doesn't work on web, so only try on mobile
      if (!kIsWeb) {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          _lastPosition = lastKnown;
          return LocationResult(
            success: true,
            position: lastKnown,
            status: await checkPermission(),
          );
        }
      }
      return LocationResult(
        success: false,
        message: 'Location timeout. Please enable location in your browser.',
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return LocationResult(
        success: false,
        message: 'Failed to get location: ${e.toString()}',
      );
    }
  }

  /// Start continuous location updates
  void startLocationUpdates({
    required void Function(Position position) onLocationUpdate,
    void Function(String error)? onError,
  }) {
    stopLocationUpdates();

    late final LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'TaybGo Driver is online',
          notificationText:
              'Live location sharing stays active while you are online.',
          notificationChannelName: 'Driver live location',
          notificationIcon: AndroidResource(name: 'ic_notification'),
          enableWakeLock: true,
          setOngoing: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: false,
        allowBackgroundLocationUpdates: true,
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );
    }

    debugPrint('[LocationService] === STARTING LOCATION STREAM ===');
    debugPrint('[LocationService] Accuracy: navigation, Distance filter: 25m');

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            debugPrint('[LocationService] === POSITION STREAM EVENT ===');
            debugPrint(
              '[LocationService] New position: ${position.latitude}, ${position.longitude}',
            );
            debugPrint(
              '[LocationService] Accuracy: ${position.accuracy}m, Speed: ${position.speed}m/s',
            );
            if (_lastPosition != null) {
              final distance = Geolocator.distanceBetween(
                _lastPosition!.latitude,
                _lastPosition!.longitude,
                position.latitude,
                position.longitude,
              );
              debugPrint(
                '[LocationService] Distance from last: ${distance.toStringAsFixed(1)}m',
              );
            }
            _lastPosition = position;
            onLocationUpdate(position);
          },
          onError: (error) {
            debugPrint('[LocationService] === LOCATION STREAM ERROR ===');
            debugPrint('[LocationService] Error: $error');
            onError?.call('Location tracking error');
          },
        );
    debugPrint('[LocationService] Location stream started');
  }

  /// Stop location updates
  void stopLocationUpdates() {
    if (_positionStream != null) {
      debugPrint('[LocationService] === STOPPING LOCATION STREAM ===');
    }
    _positionStream?.cancel();
    _positionStream = null;
  }

  /// Open app settings (for when permission is denied forever)
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Open location settings (for when service is disabled)
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  String _getStatusMessage(LocationPermissionStatus status) {
    return _getPermissionMessage(status, requireBackgroundAccess: false);
  }

  String _getPermissionMessage(
    LocationPermissionStatus status, {
    required bool requireBackgroundAccess,
  }) {
    switch (status) {
      case LocationPermissionStatus.grantedForegroundOnly:
        return requireBackgroundAccess
            ? 'Allow background location ("Always") so TaybGo Driver can keep sending your live location while the app is in the background.'
            : '';
      case LocationPermissionStatus.denied:
        return 'Location permission denied. Please allow location access to go online.';
      case LocationPermissionStatus.deniedForever:
        return 'Location permission permanently denied. Please enable it in app settings.';
      case LocationPermissionStatus.serviceDisabled:
        return 'Location services are disabled. Please enable GPS to go online.';
      case LocationPermissionStatus.grantedAlways:
        return '';
    }
  }

  /// Get user-friendly message for location status
  String getStatusMessage(
    LocationPermissionStatus status, {
    bool requireBackgroundAccess = false,
  }) {
    return _getPermissionMessage(
      status,
      requireBackgroundAccess: requireBackgroundAccess,
    );
  }

  /// Dispose resources
  void dispose() {
    stopLocationUpdates();
  }

  Future<LocationPermissionStatus> _mapPermission(
    LocationPermission permission,
  ) async {
    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return LocationPermissionStatus.serviceDisabled;
        }
        return permission == LocationPermission.always
            ? LocationPermissionStatus.grantedAlways
            : LocationPermissionStatus.grantedForegroundOnly;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }
}
