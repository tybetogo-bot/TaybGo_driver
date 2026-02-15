import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/cache_service.dart';
import '../api/api_client.dart';

const _onboardingCompleteKey = 'onboarding_complete';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthStatus _status = AuthStatus.initial;
  bool _isLoading = false;
  String? _error;
  String? _phoneNumber;
  bool _isNewUser = false;
  bool _onboardingComplete = false;
  bool _initialized = false;
  String? _debugOtp;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    // Set up callback for token refresh failures
    _authService.setTokenRefreshFailedCallback(() {
      debugPrint('[AuthProvider] Token refresh failed callback - forcing logout');
      _status = AuthStatus.unauthenticated;
      _phoneNumber = null;
      _isNewUser = false;
      notifyListeners();
    });
  }

  AuthStatus get status => _status;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get phoneNumber => _phoneNumber;
  bool get isNewUser => _isNewUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get onboardingComplete => _onboardingComplete;
  bool get initialized => _initialized;
  String? get debugOtp => _debugOtp;

  AuthService get authService => _authService;

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
    _isLoading = true;
    _error = null;
    _phoneNumber = phoneNumber;
    _debugOtp = null;
    notifyListeners();

    try {
      debugPrint('[AuthProvider] Requesting OTP for: $phoneNumber');
      final response = await _authService.requestOtp(phoneNumber);
      debugPrint('[AuthProvider] OTP response received - debugOtp: ${response.debugOtp}');
      _debugOtp = response.debugOtp;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      debugPrint('[AuthProvider] ApiException: ${e.message}');
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('[AuthProvider] Unknown error: $e');
      _error = 'Failed to send OTP. Please try again.';
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
    notifyListeners();

    try {
      final response = await _authService.verifyOtp(
        phoneNumber: _phoneNumber!,
        otp: otp,
      );

      _isNewUser = response.isNewUser;
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to verify OTP. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

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

    _status = AuthStatus.unauthenticated;
    _phoneNumber = null;
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
}
