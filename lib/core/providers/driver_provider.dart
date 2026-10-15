import 'dart:async';

import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../models/driver_address.dart';
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
  int _stateGeneration = 0;
  bool _wasOnlineBeforeLogout = false;

  final DriverService _driverService;
  final LocationService _locationService;
  final GeocodingService _geocodingService;

  DriverProfile? _profile;
  bool _isLoading = false;
  String? _error;
  LocationPermissionStatus? _locationStatus;
  String? _currentPlaceName;
  DateTime? _lastLocationUpdate;
  bool?
  _profileExists; // null = unknown, true = has profile, false = no profile (needs registration)

  Timer? _forceLocationTimer;
  Timer? _locationPermissionCheckTimer;
  bool _locationPermissionLost = false;

  // Tour mode reference (will be set after initialization)
  bool Function()? _isTourActive;

  DriverProvider({DriverService? driverService, ApiClient? apiClient})
    : _driverService =
          driverService ?? DriverService(apiClient: apiClient ?? ApiClient()),
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
  bool get locationPermissionLost => _locationPermissionLost;

  /// Returns true if profile exists, false if no profile (403), null if unknown
  bool? get profileExists => _profileExists;

  Future<void> fetchProfile() async {
    final generation = _stateGeneration;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final loadedProfile = await _driverService.getProfile();
      if (generation != _stateGeneration) return;
      _profile = loadedProfile;
      _profileExists = true;
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      if (generation != _stateGeneration) return;
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
      if (generation != _stateGeneration) return;
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
    DriverAddress? address,
  }) async {
    final generation = _stateGeneration;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final loadedProfile = await _driverService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        vehicleType: vehicleType,
        vehiclePlate: vehiclePlate,
        address: address,
      );
      if (generation != _stateGeneration) return false;
      _profile = loadedProfile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (generation != _stateGeneration) return false;
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUserProfile({
    String? name,
    String? phone,
    DateTime? birthdate,
    String? vehicleType,
    bool clearCarDetails = false,
    String? carSize,
    String? vehiclePlateNumber,
    String? vehicleColor,
    String? vehicleMake,
    String? vehicleModel,
    int? vehicleYear,
    bool? acceptsFood,
    bool? acceptsShipping,
    bool? acceptsTaxi,
    String? drivingLicense,
    String? idDocument,
    String? otherDocuments,
    String? healthInsuranceDocument,
    String? addressDocument,
    String? bankDocument,
    DriverAddress? address,
  }) async {
    final generation = _stateGeneration;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProfile = await _driverService.updateUserProfile(
        name: name,
        phone: phone,
        birthdate: birthdate,
        vehicleType: vehicleType,
        clearCarDetails: clearCarDetails,
        carSize: carSize,
        vehiclePlateNumber: vehiclePlateNumber,
        vehicleColor: vehicleColor,
        vehicleMake: vehicleMake,
        vehicleModel: vehicleModel,
        vehicleYear: vehicleYear,
        acceptsFood: acceptsFood,
        acceptsShipping: acceptsShipping,
        acceptsTaxi: acceptsTaxi,
        drivingLicense: drivingLicense,
        idDocument: idDocument,
        otherDocuments: otherDocuments,
        healthInsuranceDocument: healthInsuranceDocument,
        addressDocument: addressDocument,
        bankDocument: bankDocument,
        address: address,
      );
      if (generation != _stateGeneration) return false;
      _profile = updatedProfile;
      notifyListeners();
      // Refresh driver profile to reflect changes
      await fetchProfile();
      if (generation != _stateGeneration) return false;
      return true;
    } catch (e) {
      if (generation != _stateGeneration) return false;
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Toggle online status — independent of location.
  /// Location tracking starts after going online, not before.
  Future<ToggleOnlineResult> toggleOnline() async {
    final generation = _stateGeneration;
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
      if (generation != _stateGeneration) return ToggleOnlineResult.apiError;
      if (locationResult != ToggleOnlineResult.success) {
        _isLoading = false;
        notifyListeners();
        return locationResult;
      }
    }

    // Optimistic update — UI flips immediately
    try {
      final confirmedStatus = await _driverService.toggleOnlineStatus(
        newStatus,
      );
      if (generation != _stateGeneration) return ToggleOnlineResult.apiError;
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
      if (generation != _stateGeneration) return ToggleOnlineResult.apiError;
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return ToggleOnlineResult.apiError;
    }
  }

  Future<ToggleOnlineResult> _ensureLocationReadyForOnline() async {
    final generation = _stateGeneration;
    var status = await _locationService.checkPermission();
    if (generation != _stateGeneration) return ToggleOnlineResult.apiError;
    if (!status.hasForegroundAccess) {
      status = await _locationService.requestPermission();
      if (generation != _stateGeneration) return ToggleOnlineResult.apiError;
    }
    _locationStatus = status;

    final permissionResult = _mapPermissionStatusToToggleResult(status);
    if (permissionResult != ToggleOnlineResult.success) {
      _error = _locationService.getStatusMessage(status);
      notifyListeners();
      return permissionResult;
    }

    if (!status.hasBackgroundAccess) {
      status = await _locationService.requestBackgroundPermission();
      if (generation != _stateGeneration) return ToggleOnlineResult.apiError;
      _locationStatus = status;
      if (!status.hasForegroundAccess) {
        final mappedResult = _mapPermissionStatusToToggleResult(status);
        _error = _locationService.getStatusMessage(status);
        notifyListeners();
        return mappedResult;
      }
    }

    final locationResult = await _locationService.getCurrentLocation();
    if (generation != _stateGeneration) return ToggleOnlineResult.apiError;
    if (!locationResult.success || locationResult.position == null) {
      final failureStatus = locationResult.status;
      if (failureStatus != null) {
        _locationStatus = failureStatus;
        final mappedResult = _mapPermissionStatusToToggleResult(failureStatus);
        if (mappedResult != ToggleOnlineResult.success) {
          _error =
              locationResult.message ??
              _locationService.getStatusMessage(failureStatus);
          notifyListeners();
          return mappedResult;
        }
      }

      _error =
          locationResult.message ??
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
      if (generation != _stateGeneration) return ToggleOnlineResult.apiError;
    } catch (e) {
      if (generation != _stateGeneration) return ToggleOnlineResult.apiError;
      _error = 'Failed to send location. Please try again.';
      notifyListeners();
      return ToggleOnlineResult.locationUnavailable;
    }

    return ToggleOnlineResult.success;
  }

  ToggleOnlineResult _mapPermissionStatusToToggleResult(
    LocationPermissionStatus status,
  ) {
    switch (status) {
      case LocationPermissionStatus.grantedForegroundOnly:
      case LocationPermissionStatus.grantedAlways:
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
    final generation = _stateGeneration;
    // Start periodic permission monitoring
    _startLocationPermissionMonitoring();

    _locationService.checkPermission().then((status) async {
      if (generation != _stateGeneration || !isOnline) return;
      _locationStatus = status;
      _locationPermissionLost = !status.hasForegroundAccess;

      if (!status.hasForegroundAccess) {
        debugPrint('[DriverProvider] Location permission not granted: $status');
        notifyListeners();
        return;
      }

      // Keep the position stream running — this keeps the Android foreground
      // service alive and refreshes `locationService.lastPosition` on every fix.
      _locationService.startLocationUpdates(
        onLocationUpdate: (_) {},
        onError: (error) {
          debugPrint('[DriverProvider] Location update error: $error');
        },
      );

      // Immediate first POST so the server sees us as soon as we go online.
      final result = await _locationService.getCurrentLocation();
      if (generation != _stateGeneration || !isOnline) return;
      if (result.success && result.position != null) {
        await updateLocation(
          result.position!.latitude,
          result.position!.longitude,
        );
      }

      if (generation != _stateGeneration || !isOnline) return;
      // Fixed 10-second heartbeat — POSTs the latest known position whether
      // or not the driver is moving. Works in foreground and background
      // (background requires "Always" permission + active foreground service).
      _forceLocationTimer?.cancel();
      _forceLocationTimer = Timer.periodic(const Duration(seconds: 60), (
        _,
      ) async {
        if (!(_profile?.isOnline ?? false)) return;
        final pos = _locationService.lastPosition;
        if (pos == null) return;
        await updateLocation(pos.latitude, pos.longitude);
      });

      notifyListeners();
    });
  }

  /// Stop location tracking when going offline
  void _stopLocationTracking() {
    _forceLocationTimer?.cancel();
    _forceLocationTimer = null;
    _stopLocationPermissionMonitoring();
    _locationService.stopLocationUpdates();
    _currentPlaceName = null;
    _lastLocationUpdate = null;
    _geocodingService.clearCache();
  }

  /// Start periodic location permission checks while online
  void _startLocationPermissionMonitoring() {
    final generation = _stateGeneration;
    _locationPermissionCheckTimer?.cancel();
    _locationPermissionLost = false;
    _locationPermissionCheckTimer = Timer.periodic(const Duration(seconds: 30), (
      _,
    ) async {
      if (!(_profile?.isOnline ?? false)) return;
      final status = await _locationService.checkPermission();
      if (generation != _stateGeneration || !isOnline) return;
      _locationStatus = status;
      final wasLost = _locationPermissionLost;
      _locationPermissionLost = !status.hasForegroundAccess;
      if (_locationPermissionLost != wasLost) {
        debugPrint(
          '[DriverProvider] Location permission changed: lost=$_locationPermissionLost, status=$status',
        );
        notifyListeners();
      }
    });
  }

  /// Stop location permission monitoring
  void _stopLocationPermissionMonitoring() {
    _locationPermissionCheckTimer?.cancel();
    _locationPermissionCheckTimer = null;
    if (_locationPermissionLost) {
      _locationPermissionLost = false;
      notifyListeners();
    }
  }

  /// Resume location tracking if the driver is already online (e.g. on app restart)
  void resumeLocationTrackingIfOnline() {
    if (_profile?.isOnline == true) {
      _startLocationTracking();
    }
  }

  /// Check location permission status without toggling
  Future<LocationPermissionStatus> checkLocationPermission() async {
    final generation = _stateGeneration;
    final loadedStatus = await _locationService.checkPermission();
    if (generation != _stateGeneration) return LocationPermissionStatus.denied;
    _locationStatus = loadedStatus;
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
    final generation = _stateGeneration;
    debugPrint('[DriverProvider] === SENDING LOCATION TO API ===');
    debugPrint('[DriverProvider] Coordinates: $latitude, $longitude');
    try {
      await _driverService.updateLocation(
        latitude: latitude,
        longitude: longitude,
      );
      if (generation != _stateGeneration) return;
      _lastLocationUpdate = DateTime.now();
      debugPrint('[DriverProvider] === LOCATION SENT SUCCESSFULLY ===');

      // Update place name in background
      _updatePlaceName(latitude, longitude);

      notifyListeners();
    } catch (e) {
      if (generation != _stateGeneration) return;
      debugPrint('[DriverProvider] === LOCATION UPDATE FAILED ===');
      debugPrint('[DriverProvider] Error: $e');
    }
  }

  Future<void> _updatePlaceName(double latitude, double longitude) async {
    final generation = _stateGeneration;
    final placeName = await _geocodingService.getPlaceName(latitude, longitude);
    if (generation != _stateGeneration) return;
    if (placeName != null) {
      _currentPlaceName = placeName;
    }
  }

  /// Best-effort offline sync before logout while auth tokens are still valid.
  Future<void> markOfflineBeforeLogout() async {
    final generation = _stateGeneration;
    if (_profile == null && !_wasOnlineBeforeLogout) return;

    if (!(_profile?.isOnline ?? _wasOnlineBeforeLogout)) {
      _stopLocationTracking();
      return;
    }

    if (_isTourActive?.call() == true) {
      _profile = _profile?.copyWith(isOnline: false);
      _stopLocationTracking();
      notifyListeners();
      return;
    }

    try {
      final confirmedStatus = await _driverService.toggleOnlineStatus(
        false,
        sessionCleanup: true,
      );
      if (generation != _stateGeneration) return;
      _profile = _profile?.copyWith(isOnline: confirmedStatus);
      if (!confirmedStatus) {
        _stopLocationTracking();
      }
      notifyListeners();
    } catch (e) {
      if (generation != _stateGeneration) return;
      debugPrint(
        '[DriverProvider] Failed to mark driver offline before logout: $e',
      );
    }
  }

  void pauseForLogout() {
    _wasOnlineBeforeLogout = _profile?.isOnline ?? false;
    ++_stateGeneration;
    _stopLocationTracking();
    _profile = null;
    _profileExists = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearProfile() {
    pauseForLogout();
    _wasOnlineBeforeLogout = false;
    _isLoading = false;
    _profile = null;
    _profileExists = null;
    _error = null;
    _locationStatus = null;
    _currentPlaceName = null;
    _lastLocationUpdate = null;
    _locationPermissionLost = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    ++_stateGeneration;
    _stopLocationTracking();
    super.dispose();
  }
}
