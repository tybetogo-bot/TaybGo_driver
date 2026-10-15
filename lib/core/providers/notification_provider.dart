import 'dart:async';
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
  StreamSubscription<String>? _tokenRefreshSubscription;
  Timer? _registrationRetry;
  int _pushSession = 0;
  bool _pushActive = false;
  Future<void>? _pushCleanup;
  String? _registeredToken;
  bool _pushStopped = false;
  bool _hasLoadedNotifications = false;
  int _inboxRevision = 0;
  int _inboxRequest = 0;
  final Set<int> _pendingReads = {};
  final Set<int> _dismissedIds = {};

  NotificationProvider({
    NotificationService? notificationService,
    ApiClient? apiClient,
    FcmService? fcmService,
  }) : _notificationService =
           notificationService ??
           NotificationService(apiClient: apiClient ?? ApiClient()),
       _fcmService = fcmService ?? FcmService();

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTokenRegistered => _isTokenRegistered;
  bool get hasLoadedNotifications => _hasLoadedNotifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get todayNotifications {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    return _notifications
        .where((n) => n.createdAt.isAfter(todayStart))
        .toList();
  }

  List<NotificationModel> get yesterdayNotifications {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    return _notifications
        .where(
          (n) =>
              n.createdAt.isAfter(yesterdayStart) &&
              n.createdAt.isBefore(todayStart),
        )
        .toList();
  }

  List<NotificationModel> get earlierNotifications {
    final now = DateTime.now();
    final yesterdayStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 1));
    return _notifications
        .where((n) => n.createdAt.isBefore(yesterdayStart))
        .toList();
  }

  /// Retrieve the FCM token, register it with the backend, and listen for refreshes.
  /// Call this after the user is authenticated.
  Future<void> initializePushNotifications() async {
    if (_pushActive) return;
    _pushActive = true;
    final session = ++_pushSession;
    await _pushCleanup;
    if (!_pushActive || session != _pushSession) return;
    _pushStopped = false;
    _fcmService.startPushForSignedInUser();
    _tokenRefreshSubscription = _fcmService.onTokenRefresh((token) {
      if (_pushActive && session == _pushSession) {
        unawaited(registerDeviceToken(token));
      }
    });
    await _tryRegisterToken(session);
  }

  Future<void> _tryRegisterToken(int session) async {
    final token = await _fcmService.getToken();
    if (!_pushActive || session != _pushSession) return;
    final registered = token != null && await registerDeviceToken(token);
    if (!registered && _pushActive && session == _pushSession) {
      _registrationRetry?.cancel();
      _registrationRetry = Timer(const Duration(seconds: 30), () {
        unawaited(_tryRegisterToken(session));
      });
    }
  }

  void pausePushNotifications() {
    _pushActive = false;
    ++_pushSession;
    _registrationRetry?.cancel();
    _registrationRetry = null;
    unawaited(_tokenRefreshSubscription?.cancel());
    _tokenRefreshSubscription = null;
    _fcmService.pausePushForSignedOutUser();
  }

  Future<void> stopPushNotifications({bool unregister = true}) {
    if (_pushCleanup != null) return _pushCleanup!;
    if (_pushStopped) return Future<void>.value();
    final token = _registeredToken;
    pausePushNotifications();
    _registeredToken = null;
    return _pushCleanup = _unregisterAndStop(unregister ? token : null)
        .whenComplete(() {
          _pushStopped = true;
          _pushCleanup = null;
        });
  }

  Future<void> _unregisterAndStop(String? token) async {
    if (token != null) {
      try {
        await _notificationService
            .unregisterDeviceToken(token)
            .timeout(const Duration(seconds: 5));
      } catch (error) {
        debugPrint('[NotificationProvider] Device unregister failed: $error');
      }
    }
    // Invalidation also protects a shared device when the backend is offline.
    await _fcmService.stopPushForSignedOutUser();
  }

  /// Register FCM device token with the server
  Future<bool> registerDeviceToken(String token) async {
    final session = _pushSession;
    if (!_pushActive) return false;
    try {
      final deviceType = _getDeviceType();

      debugPrint('[NotificationProvider] Registering device token...');
      debugPrint('[NotificationProvider] Device type: $deviceType');

      _registeredToken = token;
      await _notificationService.registerDeviceToken(
        token: token,
        deviceType: deviceType,
      );

      if (session != _pushSession) return false;
      _isTokenRegistered = true;
      notifyListeners();

      debugPrint('[NotificationProvider] Device token registered successfully');
      return true;
    } catch (e) {
      debugPrint('[NotificationProvider] Failed to register device token: $e');
      if (session != _pushSession) return false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Background refreshes keep the last known count and avoid inbox spinners.
  Future<void> fetchNotifications({bool silent = false}) async {
    final session = _pushSession;
    final revision = _inboxRevision;
    final request = ++_inboxRequest;
    if (!silent) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }
    try {
      final notifications = await _notificationService.getNotifications();
      if (session != _pushSession ||
          request != _inboxRequest ||
          revision != _inboxRevision) {
        return;
      }
      _notifications = notifications
          .where((n) => !_dismissedIds.contains(n.id))
          .map(
            (n) => _pendingReads.contains(n.id) ? n.copyWith(isRead: true) : n,
          )
          .toList();
      _hasLoadedNotifications = true;
      _error = null;
      notifyListeners();
    } catch (e) {
      if (session != _pushSession || request != _inboxRequest) return;
      if (!silent) _error = e.toString();
      debugPrint('[NotificationProvider] Failed to fetch notifications: $e');
    } finally {
      if (session == _pushSession && request == _inboxRequest) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Optimistic count changes are persisted, so a refresh cannot resurrect reads.
  Future<void> markAsRead(int id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1 || _notifications[index].isRead) return;
    final original = _notifications[index];
    final session = _pushSession;
    _pendingReads.add(id);
    ++_inboxRevision;
    _notifications[index] = original.copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
    notifyListeners();
    try {
      await _notificationService.markAsRead(id);
    } catch (error) {
      if (session != _pushSession) return;
      final current = _notifications.indexWhere((n) => n.id == id);
      if (current != -1) _notifications[current] = original;
      debugPrint('[NotificationProvider] Mark read failed: $error');
    } finally {
      if (session == _pushSession) {
        _pendingReads.remove(id);
        ++_inboxRevision;
        notifyListeners();
      }
    }
  }

  Future<void> markAllAsRead() async {
    final ids = _notifications
        .where((n) => !n.isRead)
        .map((n) => n.id)
        .toList();
    await Future.wait(ids.map(markAsRead));
  }

  /// Dismissals retain their existing local-only behavior for this login.
  void deleteNotification(int id) {
    _dismissedIds.add(id);
    ++_inboxRevision;
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearInbox() {
    _dismissedIds.addAll(_notifications.map((n) => n.id));
    ++_inboxRevision;
    _notifications = [];
    notifyListeners();
  }

  /// Clear all notifications locally
  void clearAll() {
    pausePushNotifications();
    ++_inboxRevision;
    ++_inboxRequest;
    _pendingReads.clear();
    _dismissedIds.clear();
    _hasLoadedNotifications = false;
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

  @override
  void dispose() {
    _pushActive = false;
    ++_pushSession;
    _registrationRetry?.cancel();
    unawaited(_tokenRefreshSubscription?.cancel());
    super.dispose();
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
