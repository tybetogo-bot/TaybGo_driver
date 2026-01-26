import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
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
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;

  Position? get lastPosition => _lastPosition;

  /// Check if location services are enabled and we have permission
  Future<LocationPermissionStatus> checkPermission() async {
    // Check permission status first
    LocationPermission permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        // Permission granted, now check if location services are enabled
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return LocationPermissionStatus.serviceDisabled;
        }
        return LocationPermissionStatus.granted;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }

  /// Request location permission
  Future<LocationPermissionStatus> requestPermission() async {
    // Request permission first (so iOS shows Location in Settings)
    LocationPermission permission = await Geolocator.requestPermission();

    // If permission granted, check if location services are enabled
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationPermissionStatus.serviceDisabled;
      }
    }

    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationPermissionStatus.granted;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }

  /// Get current location (with permission check)
  Future<LocationResult> getCurrentLocation() async {
    // Check permission first
    final status = await checkPermission();

    if (status != LocationPermissionStatus.granted) {
      // Try to request permission
      final requestStatus = await requestPermission();
      if (requestStatus != LocationPermissionStatus.granted) {
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
      final timeout = kIsWeb ? const Duration(seconds: 30) : const Duration(seconds: 10);

      debugPrint('Getting location with accuracy: $accuracy, timeout: $timeout, isWeb: $kIsWeb');

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeout,
      );

      _lastPosition = position;
      debugPrint('Got location: ${position.latitude}, ${position.longitude}');

      return LocationResult(
        success: true,
        position: position,
        status: LocationPermissionStatus.granted,
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
            status: LocationPermissionStatus.granted,
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

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50, // Update every 50 meters
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _lastPosition = position;
        onLocationUpdate(position);
      },
      onError: (error) {
        debugPrint('Location stream error: $error');
        onError?.call('Location tracking error');
      },
    );
  }

  /// Stop location updates
  void stopLocationUpdates() {
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
    switch (status) {
      case LocationPermissionStatus.denied:
        return 'Location permission denied. Please allow location access to go online.';
      case LocationPermissionStatus.deniedForever:
        return 'Location permission permanently denied. Please enable it in app settings.';
      case LocationPermissionStatus.serviceDisabled:
        return 'Location services are disabled. Please enable GPS to go online.';
      case LocationPermissionStatus.granted:
        return '';
    }
  }

  /// Get user-friendly message for location status
  String getStatusMessage(LocationPermissionStatus status) {
    return _getStatusMessage(status);
  }

  /// Dispose resources
  void dispose() {
    stopLocationUpdates();
  }
}
