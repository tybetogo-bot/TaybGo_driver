import 'dart:async';

import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../models/driver_profile.dart';
import '../services/driver_service.dart';
import '../services/geocoding_service.dart';
import '../services/location_service.dart';

/// Result of toggling online status
enum ToggleOnlineResult {
  success,
  accountNotVerified,
  locationDenied,
  locationDeniedForever,
  locationServiceDisabled,
  locationUnavailable,
  apiError,
}

class DriverProvider extends ChangeNotifier {
  final DriverService _driverService;
  final LocationService _locationService;
  final GeocodingService _geocodingService;

  DriverProfile? _profile;
  bool _isLoading = false;
  String? _error;
  LocationPermissionStatus? _locationStatus;
  String? _currentPlaceName;
  DateTime? _lastLocationUpdate;
  bool? _profileExists; // null = unknown, true = has profile, false = no profile (needs registration)

  Timer? _forceLocationTimer;

  // Tour mode reference (will be set after initialization)
  bool Function()? _isTourActive;

  DriverProvider({DriverService? driverService, ApiClient? apiClient})
      : _driverService = driverService ??
            DriverService(apiClient: apiClient ?? ApiClient()),
        _locationService = LocationService(),
        _geocodingService = GeocodingService();

  /// Set tour mode checker (called from tour integration)
  void setTourModeChecker(bool Function() checker) {
    _isTourActive = checker;
  }

  DriverProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _profile?.isOnline ?? false;
  bool get isVerified => _profile?.isVerified ?? false;
  LocationPermissionStatus? get locationStatus => _locationStatus;
  LocationService get locationService => _locationService;
  String? get currentPlaceName => _currentPlaceName;
  DateTime? get lastLocationUpdate => _lastLocationUpdate;
  /// Returns true if profile exists, false if no profile (403), null if unknown
  bool? get profileExists => _profileExists;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _driverService.getProfile();
      _profileExists = true;
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      // 403 means user doesn't have a driver profile yet
      if (e.statusCode == 403 || e.statusCode == 404) {
        _profileExists = false;
        _error = null; // Clear error since this is expected for new users
      } else {
        _error = e.message;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? vehicleType,
    String? vehiclePlate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _driverService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        vehicleType: vehicleType,
        vehiclePlate: vehiclePlate,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Toggle online status — independent of location.
  /// Location tracking starts after going online, not before.
  Future<ToggleOnlineResult> toggleOnline() async {
    if (_profile == null) return ToggleOnlineResult.apiError;
    if (_isLoading) return ToggleOnlineResult.apiError;

    final newStatus = !_profile!.isOnline;

    // Tour mode: Simulate toggle without API call
    if (_isTourActive?.call() == true) {
      _profile = _profile!.copyWith(isOnline: newStatus);
      notifyListeners();
      return ToggleOnlineResult.success;
    }

    // Check account verification first
    if (newStatus && !_profile!.isVerified) {
      return ToggleOnlineResult.accountNotVerified;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    if (newStatus) {
      final locationResult = await _ensureLocationReadyForOnline();
      if (locationResult != ToggleOnlineResult.success) {
        _isLoading = false;
        notifyListeners();
        return locationResult;
      }
    }

    // Optimistic update — UI flips immediately
    try {
      final confirmedStatus = await _driverService.toggleOnlineStatus(newStatus);
      _profile = _profile!.copyWith(isOnline: confirmedStatus);
      _isLoading = false;
      notifyListeners();

      if (confirmedStatus) {
        // Now online — start location tracking in background
        _startLocationTracking();
      } else {
        // Now offline — stop everything
        _stopLocationTracking();
      }

      return ToggleOnlineResult.success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return ToggleOnlineResult.apiError;
    }
  }

  Future<ToggleOnlineResult> _ensureLocationReadyForOnline() async {
    var status = await _locationService.checkPermission();
    if (status != LocationPermissionStatus.granted) {
      status = await _locationService.requestPermission();
    }
    _locationStatus = status;

    final permissionResult = _mapPermissionStatusToToggleResult(status);
    if (permissionResult != ToggleOnlineResult.success) {
      _error = _locationService.getStatusMessage(status);
      notifyListeners();
      return permissionResult;
    }

    final locationResult = await _locationService.getCurrentLocation();
    if (!locationResult.success || locationResult.position == null) {
      final failureStatus = locationResult.status;
      if (failureStatus != null) {
        _locationStatus = failureStatus;
        final mappedResult = _mapPermissionStatusToToggleResult(failureStatus);
        if (mappedResult != ToggleOnlineResult.success) {
          _error = locationResult.message ??
              _locationService.getStatusMessage(failureStatus);
          notifyListeners();
          return mappedResult;
        }
      }

      _error = locationResult.message ??
          'Unable to get your current location. Please try again.';
      notifyListeners();
      return ToggleOnlineResult.locationUnavailable;
    }

    // Send location to the API before going online
    try {
      await updateLocation(
        locationResult.position!.latitude,
        locationResult.position!.longitude,
      );
    } catch (e) {
      _error = 'Failed to send location. Please try again.';
      notifyListeners();
      return ToggleOnlineResult.locationUnavailable;
    }

    return ToggleOnlineResult.success;
  }

  ToggleOnlineResult _mapPermissionStatusToToggleResult(
      LocationPermissionStatus status) {
    switch (status) {
      case LocationPermissionStatus.granted:
        return ToggleOnlineResult.success;
      case LocationPermissionStatus.denied:
        return ToggleOnlineResult.locationDenied;
      case LocationPermissionStatus.deniedForever:
        return ToggleOnlineResult.locationDeniedForever;
      case LocationPermissionStatus.serviceDisabled:
        return ToggleOnlineResult.locationServiceDisabled;
    }
  }

  /// Start location tracking after going online
  void _startLocationTracking() {
    // Request permission, then start updates
    _locationService.checkPermission().then((status) async {
      if (status != LocationPermissionStatus.granted) {
        status = await _locationService.requestPermission();
      }
      _locationStatus = status;

      if (status != LocationPermissionStatus.granted) {
        debugPrint('[DriverProvider] Location permission not granted: $status');
        notifyListeners();
        return;
      }

      // Start continuous updates
      _locationService.startLocationUpdates(
        onLocationUpdate: (position) async {
          await updateLocation(position.latitude, position.longitude);
        },
        onError: (error) {
          debugPrint('[DriverProvider] Location update error: $error');
        },
      );

      // Also get an immediate fix
      final result = await _locationService.getCurrentLocation();
      if (result.success && result.position != null) {
        await updateLocation(
          result.position!.latitude,
          result.position!.longitude,
        );
      }

      // Force a location update every 5 minutes even if driver hasn't moved
      _forceLocationTimer?.cancel();
      _forceLocationTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
        if (!(_profile?.isOnline ?? false)) return;
        final lastUpdate = _lastLocationUpdate;
        if (lastUpdate != null &&
            DateTime.now().difference(lastUpdate).inMinutes < 5) {
          return; // Already updated recently via movement
        }
        debugPrint('[DriverProvider] === FORCED 5-MIN LOCATION UPDATE ===');
        final loc = await _locationService.getCurrentLocation();
        if (loc.success && loc.position != null) {
          await updateLocation(loc.position!.latitude, loc.position!.longitude);
        }
      });
    });
  }

  /// Stop location tracking when going offline
  void _stopLocationTracking() {
    _forceLocationTimer?.cancel();
    _forceLocationTimer = null;
    _locationService.stopLocationUpdates();
    _currentPlaceName = null;
    _lastLocationUpdate = null;
    _geocodingService.clearCache();
  }

  /// Check location permission status without toggling
  Future<LocationPermissionStatus> checkLocationPermission() async {
    _locationStatus = await _locationService.checkPermission();
    return _locationStatus!;
  }

  /// Open app settings for location permission
  Future<bool> openAppSettings() async {
    return await _locationService.openAppSettings();
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await _locationService.openLocationSettings();
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    debugPrint('[DriverProvider] === SENDING LOCATION TO API ===');
    debugPrint('[DriverProvider] Coordinates: $latitude, $longitude');
    try {
      await _driverService.updateLocation(
        latitude: latitude,
        longitude: longitude,
      );
      _lastLocationUpdate = DateTime.now();
      debugPrint('[DriverProvider] === LOCATION SENT SUCCESSFULLY ===');

      // Update place name in background
      _updatePlaceName(latitude, longitude);

      notifyListeners();
    } catch (e) {
      debugPrint('[DriverProvider] === LOCATION UPDATE FAILED ===');
      debugPrint('[DriverProvider] Error: $e');
    }
  }

  Future<void> _updatePlaceName(double latitude, double longitude) async {
    final placeName = await _geocodingService.getPlaceName(latitude, longitude);
    if (placeName != null) {
      _currentPlaceName = placeName;
    }
  }

  void clearProfile() {
    _profile = null;
    _profileExists = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
