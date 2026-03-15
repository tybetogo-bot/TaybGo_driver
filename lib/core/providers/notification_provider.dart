import 'dart:io';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../services/fcm_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;
  final FcmService _fcmService;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  bool _isTokenRegistered = false;

  NotificationProvider({
    NotificationService? notificationService,
    ApiClient? apiClient,
    FcmService? fcmService,
  })  : _notificationService = notificationService ??
            NotificationService(apiClient: apiClient ?? ApiClient()),
        _fcmService = fcmService ?? FcmService();

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTokenRegistered => _isTokenRegistered;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get todayNotifications {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return _notifications.where((n) => n.createdAt.isAfter(todayStart)).toList();
  }

  List<NotificationModel> get yesterdayNotifications {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    return _notifications
        .where((n) => n.createdAt.isAfter(yesterdayStart) && n.createdAt.isBefore(todayStart))
        .toList();
  }

  List<NotificationModel> get earlierNotifications {
    final now = DateTime.now();
    final yesterdayStart = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
    return _notifications.where((n) => n.createdAt.isBefore(yesterdayStart)).toList();
  }

  /// Retrieve the FCM token, register it with the backend, and listen for refreshes.
  /// Call this after the user is authenticated.
  Future<void> initializePushNotifications() async {
    // Get current token and register
    final token = await _fcmService.getToken();
    debugPrint('[NotificationProvider] FCM token retrieved: ${token != null ? '${token.substring(0, 20)}...' : 'NULL'}');

    if (token != null) {
      final success = await registerDeviceToken(token);
      debugPrint('[NotificationProvider] Token registration ${success ? 'SUCCEEDED' : 'FAILED'}');
    } else {
      debugPrint('[NotificationProvider] WARNING: No FCM token available — push notifications will not work');
    }

    // Re-register whenever the token rotates
    _fcmService.onTokenRefresh((newToken) {
      debugPrint('[NotificationProvider] Token rotated, re-registering...');
      registerDeviceToken(newToken);
    });
  }

  /// Register FCM device token with the server
  Future<bool> registerDeviceToken(String token) async {
    try {
      final deviceType = _getDeviceType();

      debugPrint('[NotificationProvider] Registering device token...');
      debugPrint('[NotificationProvider] Device type: $deviceType');

      await _notificationService.registerDeviceToken(
        token: token,
        deviceType: deviceType,
      );

      _isTokenRegistered = true;
      notifyListeners();

      debugPrint('[NotificationProvider] Device token registered successfully');
      return true;
    } catch (e) {
      debugPrint('[NotificationProvider] Failed to register device token: $e');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Fetch notifications from the server
  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _notificationService.getNotifications();
      _isLoading = false;
      notifyListeners();

      debugPrint('[NotificationProvider] Fetched ${_notifications.length} notifications');
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();

      debugPrint('[NotificationProvider] Failed to fetch notifications: $e');
    }
  }

  /// Mark a notification as read locally (optimistic update)
  void markAsRead(int id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(
        isRead: true,
        readAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  /// Mark all notifications as read locally
  void markAllAsRead() {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
        .toList();
    notifyListeners();
  }

  /// Delete a notification locally
  void deleteNotification(int id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  /// Clear all notifications locally
  void clearAll() {
    _notifications = [];
    _isTokenRegistered = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  /// Clear any error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _getDeviceType() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else {
      return 'unknown';
    }
  }
}
