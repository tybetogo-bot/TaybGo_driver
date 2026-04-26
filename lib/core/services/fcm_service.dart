import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';
import '../api/api_client.dart';
import '../config/app_config.dart';
import 'notification_preferences_service.dart';
import 'order_service.dart';

const String _acceptOrderActionId = 'accept_order';
const String _rejectOrderActionId = 'reject_order';
const String _notificationTypeDispatchOffer = 'dispatch_offer';
const String _notificationTypeNewOrder = 'new_order';
const String _notificationTypeOrderUpdate = 'order_update';
const String _dispatchOfferCategoryId = 'dispatch_offer';
const String _orderChannelPrefix = 'order_alerts';
const String _generalChannelPrefix = 'general';
const String _androidSoundBaseName = 'signal';

final DarwinNotificationCategory _dispatchOfferCategory =
    DarwinNotificationCategory(
      _dispatchOfferCategoryId,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain(_acceptOrderActionId, 'Accept'),
        DarwinNotificationAction.plain(
          _rejectOrderActionId,
          'Reject',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
      ],
    );

final FlutterLocalNotificationsPlugin _backgroundLocalNotifications =
    FlutterLocalNotificationsPlugin();

bool _backgroundNotificationsInitialized = false;

Map<String, dynamic> _decodeNotificationPayload(String? payload) {
  if (payload == null || payload.isEmpty) {
    return <String, dynamic>{};
  }

  try {
    final decoded = jsonDecode(payload);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
  } catch (e) {
    debugPrint('[FCM] Failed to decode notification payload: $e');
  }

  return <String, dynamic>{};
}

String? _extractOrderId(Map<String, dynamic> data) {
  final value = data['order_id'] ?? data['orderId'] ?? data['id'];
  final orderId = value?.toString().trim();
  if (orderId == null || orderId.isEmpty) {
    return null;
  }
  return orderId;
}

bool _isOrderNotification(Map<String, dynamic> data) {
  final type = data['type']?.toString();
  return type == _notificationTypeDispatchOffer ||
      type == _notificationTypeNewOrder ||
      type == _notificationTypeOrderUpdate;
}

bool _isDispatchOffer(Map<String, dynamic> data) {
  return data['type']?.toString() == _notificationTypeDispatchOffer;
}

String _androidSoundResourceName(int repeatCount) {
  return '${_androidSoundBaseName}_$repeatCount';
}

String _iosSoundFileName(int repeatCount) {
  return '${_androidSoundBaseName}_$repeatCount.wav';
}

int _notificationIdForPayload(String payload) {
  return payload.hashCode;
}

AndroidNotificationChannel _channelForPreferences({
  required int repeatCount,
  required bool soundEnabled,
  required bool vibrationEnabled,
  required bool isOrderNotification,
  String? channelIdOverride,
  String? channelNameOverride,
}) {
  final prefix = isOrderNotification
      ? _orderChannelPrefix
      : _generalChannelPrefix;
  final channelId =
      channelIdOverride ??
      '${prefix}_${soundEnabled ? 'sound' : 'silent'}_${vibrationEnabled ? 'vibrate' : 'still'}_$repeatCount';
  final channelName =
      channelNameOverride ??
      '${isOrderNotification ? 'Order Alerts' : 'General Notifications'} x$repeatCount';
  final channelDescription = soundEnabled
      ? 'Signal notification sound repeated $repeatCount time(s)'
      : 'Notifications without custom sound';

  return AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: isOrderNotification
        ? Importance.high
        : Importance.defaultImportance,
    playSound: soundEnabled,
    sound: soundEnabled
        ? RawResourceAndroidNotificationSound(
            _androidSoundResourceName(repeatCount),
          )
        : null,
    enableVibration: vibrationEnabled,
    vibrationPattern: vibrationEnabled
        ? Int64List.fromList(<int>[0, 250, 200, 250])
        : Int64List(0),
  );
}

Future<void> _handleOrderActionFromPayload({
  required String actionId,
  required String? payload,
  int? notificationId,
  FlutterLocalNotificationsPlugin? plugin,
}) async {
  final data = _decodeNotificationPayload(payload);
  final orderId = _extractOrderId(data);
  if (orderId == null) {
    debugPrint('[FCM] $actionId action ignored: missing order id');
    return;
  }

  final notificationPlugin = plugin ?? _backgroundLocalNotifications;
  final payloadJson = payload ?? jsonEncode(data);
  final statusNotificationId =
      notificationId ?? _notificationIdForPayload(payloadJson);
  final isAccept = actionId == _acceptOrderActionId;
  final actionLabel = isAccept ? 'Accept' : 'Reject';

  try {
    await AppConfig.ensureInitializedFromStorage();
    await _showOrderActionStatusNotification(
      plugin: notificationPlugin,
      id: statusNotificationId,
      title: isAccept ? 'Accepting order...' : 'Rejecting order...',
      body: 'Please wait while TaybGo updates this offer.',
      payload: payloadJson,
      playSound: false,
    );

    final orderService = OrderService();

    if (actionId == _acceptOrderActionId) {
      await orderService.acceptOrder(orderId);
      debugPrint('[FCM] Order accepted from notification action: $orderId');
      await _showOrderActionStatusNotification(
        plugin: notificationPlugin,
        id: statusNotificationId,
        title: 'Order accepted',
        body: 'Open TaybGo Driver to continue this delivery.',
        payload: payloadJson,
        playSound: true,
      );
    } else if (actionId == _rejectOrderActionId) {
      await orderService.rejectOrderById(orderId);
      debugPrint('[FCM] Order rejected from notification action: $orderId');
      await _showOrderActionStatusNotification(
        plugin: notificationPlugin,
        id: statusNotificationId,
        title: 'Order rejected',
        body: 'This dispatch offer was removed from your list.',
        payload: payloadJson,
        playSound: false,
      );
    } else {
      debugPrint('[FCM] Unknown order notification action: $actionId');
      return;
    }
  } on ApiException catch (e) {
    String title = '$actionLabel failed';
    String body = 'Tap to open the order and refresh availability.';

    switch (e.statusCode) {
      case 403:
        debugPrint('[FCM] Dispatch offer unavailable/unauthorized: $orderId');
        title = 'Offer unavailable';
        body = 'You are not eligible for this dispatch offer right now.';
        break;
      case 404:
        debugPrint('[FCM] Dispatch offer no longer exists: $orderId');
        title = 'Offer no longer available';
        body = 'This order was removed or is no longer suggested.';
        break;
      case 409:
        debugPrint('[FCM] Dispatch offer already accepted elsewhere: $orderId');
        title = 'Offer already taken';
        body = 'Another driver accepted this order.';
        break;
      default:
        debugPrint('[FCM] $actionId failed for order $orderId: ${e.message}');
        body = e.message;
    }

    await _showOrderActionStatusNotification(
      plugin: notificationPlugin,
      id: statusNotificationId,
      title: title,
      body: body,
      payload: payloadJson,
      playSound: true,
    );
  } catch (e) {
    debugPrint('[FCM] Failed to process $actionId for order $orderId: $e');
    await _showOrderActionStatusNotification(
      plugin: notificationPlugin,
      id: statusNotificationId,
      title: '$actionLabel failed',
      body: 'Tap to open the order and try again.',
      payload: payloadJson,
      playSound: true,
    );
  }
}

Future<void> _showOrderActionStatusNotification({
  required FlutterLocalNotificationsPlugin plugin,
  required int id,
  required String title,
  required String body,
  required String payload,
  required bool playSound,
}) async {
  await _ensureBackgroundNotificationsInitialized();

  const channelId = 'order_action_status';
  const channelName = 'Order Action Status';
  const channelDescription = 'Status updates for notification order actions';

  final androidPlugin = plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  await androidPlugin?.createNotificationChannel(
    const AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      playSound: true,
    ),
  );

  await plugin.show(
    id,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        color: const Color(0xFF4CAF50),
        playSound: playSound,
        autoCancel: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: playSound,
        threadIdentifier: 'order_action_status',
      ),
    ),
    payload: payload,
  );
}

Future<void> _handleOrderActionResponse(
  NotificationResponse response, {
  FlutterLocalNotificationsPlugin? plugin,
}) {
  final actionId = response.actionId;
  if (actionId != _acceptOrderActionId && actionId != _rejectOrderActionId) {
    return Future<void>.value();
  }

  return _handleOrderActionFromPayload(
    actionId: actionId!,
    payload: response.payload,
    notificationId: response.id,
    plugin: plugin,
  );
}

DarwinInitializationSettings _darwinInitializationSettings() {
  return DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    notificationCategories: <DarwinNotificationCategory>[
      _dispatchOfferCategory,
    ],
  );
}

Future<void> _ensureBackgroundNotificationsInitialized() async {
  if (_backgroundNotificationsInitialized) return;

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  final iosSettings = _darwinInitializationSettings();

  await _backgroundLocalNotifications.initialize(
    InitializationSettings(android: androidSettings, iOS: iosSettings),
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  _backgroundNotificationsInitialized = true;
}

Future<void> _ensureChannelsForPlugin(
  FlutterLocalNotificationsPlugin plugin,
  NotificationPreferences preferences,
) async {
  final androidPlugin = plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  if (androidPlugin == null) return;

  final repeatCount = NotificationPreferencesService.normalizeRepeatCount(
    preferences.repeatCount,
  );

  for (final isOrderNotification in <bool>[true, false]) {
    final channel = _channelForPreferences(
      repeatCount: repeatCount,
      soundEnabled: preferences.soundEnabled,
      vibrationEnabled: preferences.vibrationEnabled,
      isOrderNotification: isOrderNotification,
    );
    await androidPlugin.createNotificationChannel(channel);
  }

  for (final isOrderNotification in <bool>[true, false]) {
    final legacyChannelId = isOrderNotification
        ? _orderChannelPrefix
        : _generalChannelPrefix;
    final legacyChannel = _channelForPreferences(
      repeatCount: repeatCount,
      soundEnabled: preferences.soundEnabled,
      vibrationEnabled: preferences.vibrationEnabled,
      isOrderNotification: isOrderNotification,
      channelIdOverride: legacyChannelId,
      channelNameOverride: isOrderNotification ? 'Order Alerts' : 'General',
    );
    await androidPlugin.deleteNotificationChannel(legacyChannelId);
    await androidPlugin.createNotificationChannel(legacyChannel);
  }
}

Future<void> _showNotification({
  required FlutterLocalNotificationsPlugin plugin,
  required RemoteMessage message,
  required bool initializePlugin,
  required NotificationPreferences preferences,
}) async {
  final isOrderNotification = _isOrderNotification(message.data);
  final isDispatchOffer = _isDispatchOffer(message.data);
  if (isOrderNotification && !preferences.orderNotificationsEnabled) {
    debugPrint('[FCM] Order notification skipped by user settings');
    return;
  }

  final title =
      message.notification?.title ??
      message.data['title']?.toString() ??
      (isDispatchOffer ? 'New dispatch offer' : null) ??
      (isOrderNotification ? 'New order' : null);
  final body =
      message.notification?.body ??
      message.data['body']?.toString() ??
      message.data['message']?.toString() ??
      (isDispatchOffer ? 'Tap to view order details' : null);

  if (title == null && body == null) {
    debugPrint('[FCM] Skipping local notification: missing title and body');
    return;
  }

  if (initializePlugin) {
    await _ensureBackgroundNotificationsInitialized();
  }

  await _ensureChannelsForPlugin(plugin, preferences);

  final repeatCount = NotificationPreferencesService.normalizeRepeatCount(
    preferences.repeatCount,
  );
  final channel = _channelForPreferences(
    repeatCount: repeatCount,
    soundEnabled: preferences.soundEnabled,
    vibrationEnabled: preferences.vibrationEnabled,
    isOrderNotification: isOrderNotification,
  );
  final payload = jsonEncode(message.data);
  final orderId = _extractOrderId(message.data);
  final androidActions = <AndroidNotificationAction>[
    if (isDispatchOffer && orderId != null) ...<AndroidNotificationAction>[
      const AndroidNotificationAction(
        _acceptOrderActionId,
        'Accept',
        cancelNotification: false,
        showsUserInterface: false,
      ),
      const AndroidNotificationAction(
        _rejectOrderActionId,
        'Reject',
        cancelNotification: false,
        showsUserInterface: false,
      ),
    ] else if (isOrderNotification && orderId != null)
      const AndroidNotificationAction(
        _rejectOrderActionId,
        'Reject',
        cancelNotification: true,
        showsUserInterface: false,
      ),
  ];

  await plugin.show(
    message.messageId?.hashCode ?? _notificationIdForPayload(payload),
    title,
    body,
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
        playSound: preferences.soundEnabled,
        enableVibration: preferences.vibrationEnabled,
        vibrationPattern: preferences.vibrationEnabled
            ? Int64List.fromList(<int>[0, 250, 200, 250])
            : Int64List(0),
        sound: preferences.soundEnabled
            ? RawResourceAndroidNotificationSound(
                _androidSoundResourceName(repeatCount),
              )
            : null,
        actions: androidActions,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: preferences.soundEnabled,
        sound: preferences.soundEnabled ? _iosSoundFileName(repeatCount) : null,
        categoryIdentifier: isDispatchOffer && orderId != null
            ? _dispatchOfferCategoryId
            : null,
        threadIdentifier: orderId != null ? 'order_$orderId' : null,
      ),
    ),
    payload: payload,
  );
}

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await _handleOrderActionResponse(response);
}

/// Top-level background message handler.
/// Must be a top-level function (not a class method) for Firebase.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await AppConfig.ensureInitializedFromStorage();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('[FCM] Background message: ${message.messageId}');
  debugPrint('[FCM]   title: ${message.notification?.title}');
  debugPrint('[FCM]   body: ${message.notification?.body}');
  debugPrint('[FCM]   data: ${message.data}');

  final preferences = await NotificationPreferencesService().loadPreferences();

  await _showNotification(
    plugin: _backgroundLocalNotifications,
    message: message,
    initializePlugin: true,
    preferences: preferences,
  );
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
  bool _localNotificationsInitialized = false;
  Map<String, dynamic>? _pendingNotificationTapData;
  void Function(Map<String, dynamic> data)? _onNotificationTap;

  FirebaseMessaging get _messagingInstance =>
      _messaging ??= FirebaseMessaging.instance;

  /// Callback invoked when a notification is tapped.
  /// Receives the message data payload.
  void Function(Map<String, dynamic> data)? get onNotificationTap =>
      _onNotificationTap;

  set onNotificationTap(void Function(Map<String, dynamic> data)? callback) {
    _onNotificationTap = callback;

    final pendingData = _pendingNotificationTapData;
    if (callback != null && pendingData != null) {
      _pendingNotificationTapData = null;
      callback(pendingData);
    }
  }

  Future<void> initialize() async {
    if (_initialized) {
      debugPrint('[FCM] initialize() skipped: already initialized');
      return;
    }

    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await _messagingInstance.setAutoInitEnabled(false);
      debugPrint('[FCM] Auto-init disabled until push registration is needed');
    }

    final settings = await _messagingInstance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');

    if (!kIsWeb) {
      await initializeLocalNotifications();
      final preferences = await NotificationPreferencesService()
          .loadPreferences();
      await _ensureChannelsForPlugin(_localNotifications, preferences);
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    if (!kIsWeb) {
      final initialMessage = await _messagingInstance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('[FCM] App opened from terminated via notification');
        _handleNotificationTap(initialMessage);
      }

      await _messagingInstance.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: false,
      );
    }

    _initialized = true;
    debugPrint('[FCM] Initialization complete');
  }

  Future<void> initializeLocalNotifications() async {
    if (_localNotificationsInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final iosSettings = _darwinInitializationSettings();

    await _localNotifications.initialize(
      InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('[FCM] Local notification response: ${response.payload}');

        if (response.actionId == _acceptOrderActionId ||
            response.actionId == _rejectOrderActionId) {
          _handleOrderActionResponse(response, plugin: _localNotifications);
          return;
        }

        final data = _decodeNotificationPayload(response.payload);
        if (data.isNotEmpty) {
          _emitNotificationTap(data);
        }
      },
    );

    final launchDetails = await _localNotifications
        .getNotificationAppLaunchDetails();
    final launchResponse = launchDetails?.notificationResponse;
    if (launchDetails?.didNotificationLaunchApp == true &&
        launchResponse?.actionId == null) {
      final data = _decodeNotificationPayload(launchResponse?.payload);
      if (data.isNotEmpty) {
        _emitNotificationTap(data);
      }
    }

    _localNotificationsInitialized = true;
  }

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

  void onTokenRefresh(void Function(String token) callback) {
    _messagingInstance.onTokenRefresh.listen((token) {
      debugPrint('[FCM] Token refreshed: ${token.substring(0, 20)}...');
      callback(token);
    });
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('[FCM] Foreground message: ${message.messageId}');
    debugPrint('[FCM]   title: ${message.notification?.title}');
    debugPrint('[FCM]   body: ${message.notification?.body}');
    debugPrint('[FCM]   data: ${message.data}');

    final preferences = await NotificationPreferencesService()
        .loadPreferences();
    await _showNotification(
      plugin: _localNotifications,
      message: message,
      initializePlugin: false,
      preferences: preferences,
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('[FCM] Notification tap: ${message.data}');
    _emitNotificationTap(message.data);
  }

  void _emitNotificationTap(Map<String, dynamic> data) {
    final callback = _onNotificationTap;
    if (callback != null) {
      callback(data);
      return;
    }

    _pendingNotificationTapData = data;
  }
}
