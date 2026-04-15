import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BatteryOptimizationService {
  static final BatteryOptimizationService _instance =
      BatteryOptimizationService._internal();
  static const MethodChannel _channel = MethodChannel(
    'com.taybgo.driver/battery_optimization',
  );
  static const String _lastReminderKey =
      'battery_optimization_warning_last_shown';

  factory BatteryOptimizationService() => _instance;

  BatteryOptimizationService._internal();

  bool get _isSupportedPlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<bool> isBatteryOptimizationEnabled() async {
    if (!_isSupportedPlatform) return false;

    try {
      return await _channel.invokeMethod<bool>(
            'isBatteryOptimizationEnabled',
          ) ??
          false;
    } on PlatformException catch (e) {
      debugPrint(
        '[BatteryOptimizationService] Failed to read battery optimization status: ${e.code} ${e.message}',
      );
      return false;
    } on MissingPluginException {
      debugPrint(
        '[BatteryOptimizationService] Battery optimization bridge is unavailable on this platform build.',
      );
      return false;
    }
  }

  Future<bool> openBatteryOptimizationSettings() async {
    if (!_isSupportedPlatform) return false;

    try {
      return await _channel.invokeMethod<bool>(
            'openBatteryOptimizationSettings',
          ) ??
          false;
    } on PlatformException catch (e) {
      debugPrint(
        '[BatteryOptimizationService] Failed to open battery settings: ${e.code} ${e.message}',
      );
      return false;
    } on MissingPluginException {
      debugPrint(
        '[BatteryOptimizationService] Battery optimization bridge is unavailable on this platform build.',
      );
      return false;
    }
  }

  Future<bool> shouldShowReminder() async {
    if (!await isBatteryOptimizationEnabled()) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final lastShownRaw = prefs.getString(_lastReminderKey);
    if (lastShownRaw == null) {
      return true;
    }

    final lastShown = DateTime.tryParse(lastShownRaw);
    if (lastShown == null) {
      return true;
    }

    return DateTime.now().difference(lastShown) >= const Duration(hours: 24);
  }

  Future<void> markReminderShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastReminderKey, DateTime.now().toIso8601String());
  }
}
