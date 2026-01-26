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
  bool? _profileExists; // null = unknown, true = has profile, false = no profile (needs registration)

  DriverProvider({DriverService? driverService, ApiClient? apiClient})
      : _driverService = driverService ??
            DriverService(apiClient: apiClient ?? ApiClient()),
        _locationService = LocationService(),
        _geocodingService = GeocodingService();

  DriverProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _profile?.isOnline ?? false;
  bool get isVerified => _profile?.isVerified ?? false;
  LocationPermissionStatus? get locationStatus => _locationStatus;
  LocationService get locationService => _locationService;
  String? get currentPlaceName => _currentPlaceName;
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

  /// Toggle online status with location permission check
  /// Returns ToggleOnlineResult indicating success or specific failure reason
  Future<ToggleOnlineResult> toggleOnline() async {
    if (_profile == null) return ToggleOnlineResult.apiError;
    if (_isLoading) return ToggleOnlineResult.apiError;

    final newStatus = !_profile!.isOnline;

    _isLoading = true;
    notifyListeners();

    // If going online, check account verification first
    if (newStatus && !_profile!.isVerified) {
      _isLoading = false;
      notifyListeners();
      return ToggleOnlineResult.accountNotVerified;
    }

    // If going online, check location permission first
    if (newStatus) {
      final locationResult = await _locationService.getCurrentLocation();

      if (!locationResult.success) {
        _locationStatus = locationResult.status;
        _isLoading = false;
        notifyListeners();

        switch (locationResult.status) {
          case LocationPermissionStatus.denied:
            return ToggleOnlineResult.locationDenied;
          case LocationPermissionStatus.deniedForever:
            return ToggleOnlineResult.locationDeniedForever;
          case LocationPermissionStatus.serviceDisabled:
            return ToggleOnlineResult.locationServiceDisabled;
          default:
            return ToggleOnlineResult.apiError;
        }
      }

      // Send initial location to server and get place name
      if (locationResult.position != null) {
        await updateLocation(
          locationResult.position!.latitude,
          locationResult.position!.longitude,
        );
        // Also fetch place name for initial location
        _updatePlaceName(
          locationResult.position!.latitude,
          locationResult.position!.longitude,
        );
      }

      // Start continuous location updates
      _locationService.startLocationUpdates(
        onLocationUpdate: (position) {
          updateLocation(position.latitude, position.longitude);
        },
      );
    } else {
      // Going offline - stop location updates and clear place name
      _locationService.stopLocationUpdates();
      _currentPlaceName = null;
      _geocodingService.clearCache();
    }

    // Optimistic update
    _profile = _profile!.copyWith(isOnline: newStatus);
    notifyListeners();

    try {
      final confirmedStatus = await _driverService.toggleOnlineStatus(newStatus);
      _profile = _profile!.copyWith(isOnline: confirmedStatus);

      // If API says we're offline but we expected online, stop location updates
      if (!confirmedStatus && newStatus) {
        _locationService.stopLocationUpdates();
      }

      _isLoading = false;
      notifyListeners();
      return ToggleOnlineResult.success;
    } catch (e) {
      // Revert on failure
      _profile = _profile!.copyWith(isOnline: !newStatus);
      _error = e.toString();

      // Stop location updates if we failed to go online
      if (newStatus) {
        _locationService.stopLocationUpdates();
      }

      _isLoading = false;
      notifyListeners();
      return ToggleOnlineResult.apiError;
    }
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
    try {
      await _driverService.updateLocation(
        latitude: latitude,
        longitude: longitude,
      );

      // Update place name (don't await to avoid blocking)
      _updatePlaceName(latitude, longitude);
    } catch (e) {
      // Silent fail for location updates
      debugPrint('Location update failed: $e');
    }
  }

  Future<void> _updatePlaceName(double latitude, double longitude) async {
    final placeName = await _geocodingService.getPlaceName(latitude, longitude);
    if (placeName != null && placeName != _currentPlaceName) {
      _currentPlaceName = placeName;
      notifyListeners();
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
