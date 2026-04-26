import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferences {
  const NotificationPreferences({
    required this.orderNotificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.repeatCount,
  });

  final bool orderNotificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final int repeatCount;

  NotificationPreferences copyWith({
    bool? orderNotificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    int? repeatCount,
  }) {
    return NotificationPreferences(
      orderNotificationsEnabled:
          orderNotificationsEnabled ?? this.orderNotificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      repeatCount: repeatCount ?? this.repeatCount,
    );
  }
}

class NotificationPreferencesService {
  static const String _orderNotificationsKey = 'notification_order_enabled';
  static const String _soundEnabledKey = 'notification_sound_enabled';
  static const String _vibrationEnabledKey = 'notification_vibration_enabled';
  static const String _repeatCountKey = 'notification_repeat_count';

  static const int minRepeatCount = 1;
  static const int maxRepeatCount = 5;
  static const int defaultRepeatCount = maxRepeatCount;

  Future<NotificationPreferences> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    return NotificationPreferences(
      orderNotificationsEnabled: prefs.getBool(_orderNotificationsKey) ?? true,
      soundEnabled: prefs.getBool(_soundEnabledKey) ?? true,
      vibrationEnabled: prefs.getBool(_vibrationEnabledKey) ?? true,
      repeatCount: _normalizeRepeatCount(
        prefs.getInt(_repeatCountKey) ?? defaultRepeatCount,
      ),
    );
  }

  Future<void> saveOrderNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_orderNotificationsKey, value);
  }

  Future<void> saveSoundEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, value);
  }

  Future<void> saveVibrationEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationEnabledKey, value);
  }

  Future<void> saveRepeatCount(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_repeatCountKey, _normalizeRepeatCount(value));
  }

  static int normalizeRepeatCount(int value) => _normalizeRepeatCount(value);

  static int _normalizeRepeatCount(int value) {
    return value.clamp(minRepeatCount, maxRepeatCount);
  }
}
