import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level background message handler.
/// Must be a top-level function (not a class method) for Firebase.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message: ${message.messageId}');
  debugPrint('[FCM]   title: ${message.notification?.title}');
  debugPrint('[FCM]   body: ${message.notification?.body}');
  debugPrint('[FCM]   data: ${message.data}');
}

/// Manages Firebase Cloud Messaging setup, token lifecycle,
/// foreground notification display, and notification tap handling.
class FcmService {
  static final FcmService _instance = FcmService._();
  factory FcmService() => _instance;
  FcmService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging? _messaging;
  bool _initialized = false;

  FirebaseMessaging get _messagingInstance =>
      _messaging ??= FirebaseMessaging.instance;

  /// Android notification channel for order alerts
  static const AndroidNotificationChannel orderChannel =
      AndroidNotificationChannel(
        'order_alerts',
        'Order Alerts',
        description: 'Notifications for new orders and order updates',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

  /// Android notification channel for general messages
  static const AndroidNotificationChannel generalChannel =
      AndroidNotificationChannel(
        'general',
        'General',
        description: 'General app notifications',
        importance: Importance.defaultImportance,
      );

  /// Callback invoked when a notification is tapped.
  /// Receives the message data payload.
  void Function(Map<String, dynamic> data)? onNotificationTap;

  /// Initialize FCM — call once after Firebase.initializeApp()
  Future<void> initialize() async {
    if (_initialized) {
      debugPrint('[FCM] initialize() skipped: already initialized');
      return;
    }

    if (!kIsWeb) {
      // Background handler and local notifications are not supported on web
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Avoid background token bootstrap before the authenticated flow
      // explicitly asks for a device token.
      await _messagingInstance.setAutoInitEnabled(false);
      debugPrint('[FCM] Auto-init disabled until push registration is needed');
    }

    // Request permission (iOS + Android 13+ + web)
    final settings = await _messagingInstance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');

    if (!kIsWeb) {
      // Create Android notification channels
      await _createNotificationChannels();

      // Initialize local notifications plugin
      await _initLocalNotifications();
    }

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    if (!kIsWeb) {
      // Handle notification tap that launched the app from terminated state
      final initialMessage = await _messagingInstance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('[FCM] App opened from terminated via notification');
        _handleNotificationTap(initialMessage);
      }

      // Set foreground notification presentation options for iOS
      await _messagingInstance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    _initialized = true;
    debugPrint('[FCM] Initialization complete');
  }

  /// Get the current FCM token. Returns null if unavailable.
  Future<String?> getToken() async {
    try {
      if (!kIsWeb) {
        await _messagingInstance.setAutoInitEnabled(true);
        debugPrint('[FCM] Auto-init enabled for token retrieval');
      }

      final token = await _messagingInstance.getToken();
      debugPrint('[FCM] Token: ${token?.substring(0, 20)}...');
      return token;
    } catch (e) {
      debugPrint('[FCM] Error getting token: $e');
      return null;
    }
  }

  /// Listen for token refreshes. Call the provided callback with the new token.
  void onTokenRefresh(void Function(String token) callback) {
    _messagingInstance.onTokenRefresh.listen((token) {
      debugPrint('[FCM] Token refreshed: ${token.substring(0, 20)}...');
      callback(token);
    });
  }

  // ========== Private ==========

  Future<void> _createNotificationChannels() async {
    if (kIsWeb) return;
    // Only relevant for Android but safe to call on iOS (resolves to null).

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(orderChannel);
    await androidPlugin.createNotificationChannel(generalChannel);
    debugPrint('[FCM] Android notification channels created');
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // Already requested via FirebaseMessaging
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
        debugPrint('[FCM] Local notification tapped: ${response.payload}');
        // The payload could carry the data JSON if needed in the future
      },
    );
  }

  /// Display a foreground message as a local notification (Android heads-up).
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[FCM] Foreground message: ${message.messageId}');
    debugPrint('[FCM]   title: ${message.notification?.title}');
    debugPrint('[FCM]   body: ${message.notification?.body}');
    debugPrint('[FCM]   data: ${message.data}');

    final notification = message.notification;
    if (notification == null) return;

    // Determine which channel to use based on data payload
    final isOrderNotification =
        message.data['type'] == 'new_order' ||
        message.data['type'] == 'order_update';
    final channel = isOrderNotification ? orderChannel : generalChannel;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          priority: isOrderNotification
              ? Priority.high
              : Priority.defaultPriority,
          icon: '@drawable/ic_notification',
          color: const Color(0xFF4CAF50),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// Handle when user taps a notification (background or terminated).
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('[FCM] Notification tap: ${message.data}');
    onNotificationTap?.call(message.data);
  }
}
