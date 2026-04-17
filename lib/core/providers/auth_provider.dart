import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/cache_service.dart';
import '../api/api_client.dart';

const _onboardingCompleteKey = 'onboarding_complete';

enum AuthStatus { initial, authenticated, unauthenticated }

enum AuthErrorCode { phoneAlreadyRegistered }

class AuthProvider extends ChangeNotifier {
  static const String driverTargetRole = 'driver';

  final AuthService _authService;
  final String _appTargetRole;

  AuthStatus _status = AuthStatus.initial;
  bool _isLoading = false;
  String? _error;
  AuthErrorCode? _errorCode;
  String? _phoneNumber;
  String? _otpTargetRole;
  bool _isNewUser = false;
  bool _onboardingComplete = false;
  bool _initialized = false;
  String? _debugOtp;

  /// Called when logout happens (including forced logout from token expiry)
  /// so other providers can clear their in-memory data.
  VoidCallback? onLogoutCallback;
  Future<void> Function()? onBeforeLogoutCallback;

  AuthProvider({
    AuthService? authService,
    String appTargetRole = driverTargetRole,
  }) : _authService = authService ?? AuthService(),
       _appTargetRole = appTargetRole {
    // Set up callback for token refresh failures
    _authService.setTokenRefreshFailedCallback(() {
      debugPrint(
        '[AuthProvider] Token refresh failed callback - forcing logout',
      );
      onLogoutCallback?.call();
      _status = AuthStatus.unauthenticated;
      _phoneNumber = null;
      _isNewUser = false;
      notifyListeners();
    });
  }

  AuthStatus get status => _status;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AuthErrorCode? get errorCode => _errorCode;
  String? get phoneNumber => _phoneNumber;
  bool get isNewUser => _isNewUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get onboardingComplete => _onboardingComplete;
  bool get initialized => _initialized;
  String? get debugOtp => _debugOtp;
  String get otpTargetRole => _otpTargetRole ?? _appTargetRole;

  AuthService get authService => _authService;

  String? localizedError(AppLocalizations l10n) {
    return switch (_errorCode) {
      AuthErrorCode.phoneAlreadyRegistered =>
        l10n.errorsAuthPhoneAlreadyRegistered,
      null => _error,
    };
  }

  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool(_onboardingCompleteKey) ?? false;

    final hasTokens = await _authService.isAuthenticated();
    _status = hasTokens ? AuthStatus.authenticated : AuthStatus.unauthenticated;

    _initialized = true;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final hasTokens = await _authService.isAuthenticated();
    _status = hasTokens ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
    _onboardingComplete = true;
    notifyListeners();
  }

  Future<bool> requestOtp(String phoneNumber) async {
    final targetRole = _otpTargetRole ?? _appTargetRole;

    _isLoading = true;
    _error = null;
    _errorCode = null;
    _phoneNumber = phoneNumber;
    _otpTargetRole = targetRole;
    _debugOtp = null;
    notifyListeners();

    try {
      debugPrint('[AuthProvider] Requesting OTP for: $phoneNumber');
      final response = await _authService.requestOtp(
        phoneNumber: phoneNumber,
        targetRole: targetRole,
      );
      debugPrint(
        '[AuthProvider] OTP response received - debugOtp: ${response.debugOtp}',
      );
      _debugOtp = response.debugOtp;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      debugPrint('[AuthProvider] ApiException: ${e.message}');
      _setOtpError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('[AuthProvider] Unknown error: $e');
      _error = 'Failed to send OTP. Please try again.';
      _errorCode = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    if (_phoneNumber == null) {
      _error = 'Phone number not set';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    _errorCode = null;
    notifyListeners();

    try {
      final targetRole = _otpTargetRole ?? _appTargetRole;
      final response = await _authService.verifyOtp(
        phoneNumber: _phoneNumber!,
        otp: otp,
        targetRole: targetRole,
      );

      _isNewUser = response.isNewUser;
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setOtpError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to verify OTP. Please try again.';
      _errorCode = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await onBeforeLogoutCallback?.call();
    } catch (e) {
      debugPrint('[AuthProvider] Error during pre-logout hook: $e');
    }

    try {
      await _authService.logout();
    } catch (e) {
      debugPrint('[AuthProvider] Error during logout API call: $e');
    }

    // Clear all cache and saved data
    try {
      await CacheService.clearAllCache();
    } catch (e) {
      debugPrint('[AuthProvider] Error clearing cache: $e');
    }

    // Notify other providers to clear their in-memory data
    onLogoutCallback?.call();

    _status = AuthStatus.unauthenticated;
    _phoneNumber = null;
    _otpTargetRole = null;
    _isNewUser = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('[AuthProvider] Deleting account');
      await _authService.deleteAccount();

      // Clear all user state
      _status = AuthStatus.unauthenticated;
      _phoneNumber = null;
      _otpTargetRole = null;
      _isNewUser = false;
      _onboardingComplete = false;

      // Clear onboarding preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingCompleteKey);

      debugPrint('[AuthProvider] Account deleted successfully');
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      debugPrint('[AuthProvider] Delete account error: ${e.message}');
      _error = e.message;
      _isLoading = false;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    } catch (e) {
      debugPrint('[AuthProvider] Unknown error during account deletion: $e');
      _error = 'Failed to delete account. Please try again.';
      _isLoading = false;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    _errorCode = null;
    notifyListeners();
  }

  /// Mark user as no longer new (profile has been created)
  void clearNewUserFlag() {
    _isNewUser = false;
    notifyListeners();
  }

  /// Handle token refresh failures by logging out
  /// Call this when catching exceptions from API calls
  Future<void> handleAuthenticationError() async {
    debugPrint('[AuthProvider] Handling authentication error - forcing logout');
    await logout();
  }

  void _setOtpError(ApiException exception) {
    if (_isPhoneAlreadyRegisteredConflict(exception)) {
      _error = null;
      _errorCode = AuthErrorCode.phoneAlreadyRegistered;
      return;
    }

    _error = exception.message;
    _errorCode = null;
  }

  bool _isPhoneAlreadyRegisteredConflict(ApiException exception) {
    if (exception.statusCode == 409) {
      return true;
    }

    final normalizedText = _extractErrorText(exception).toLowerCase();
    const conflictMarkers = [
      'already registered',
      'already exists',
      'already in use',
      'registered as',
      'role conflict',
      'belongs to another',
      'associated with another',
    ];

    return conflictMarkers.any(normalizedText.contains);
  }

  String _extractErrorText(ApiException exception) {
    final buffer = StringBuffer(exception.message);
    final data = exception.data;

    if (data is Map) {
      for (final key in const ['detail', 'message', 'error']) {
        final value = data[key];
        if (value != null) {
          buffer.write(' ${value.toString()}');
        }
      }
    }

    return buffer.toString();
  }
}
