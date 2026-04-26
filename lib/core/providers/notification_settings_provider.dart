import 'package:flutter/foundation.dart';

import '../services/notification_preferences_service.dart';

class NotificationSettingsProvider extends ChangeNotifier {
  NotificationSettingsProvider({
    NotificationPreferencesService? preferencesService,
  }) : _preferencesService =
           preferencesService ?? NotificationPreferencesService() {
    _load();
  }

  final NotificationPreferencesService _preferencesService;

  NotificationPreferences _preferences = const NotificationPreferences(
    orderNotificationsEnabled: true,
    soundEnabled: true,
    vibrationEnabled: true,
    repeatCount: NotificationPreferencesService.defaultRepeatCount,
  );
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  bool get orderNotificationsEnabled => _preferences.orderNotificationsEnabled;
  bool get soundEnabled => _preferences.soundEnabled;
  bool get vibrationEnabled => _preferences.vibrationEnabled;
  int get repeatCount => _preferences.repeatCount;
  NotificationPreferences get preferences => _preferences;

  Future<void> _load() async {
    _preferences = await _preferencesService.loadPreferences();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setOrderNotificationsEnabled(bool value) async {
    _preferences = _preferences.copyWith(orderNotificationsEnabled: value);
    notifyListeners();
    await _preferencesService.saveOrderNotificationsEnabled(value);
  }

  Future<void> setSoundEnabled(bool value) async {
    _preferences = _preferences.copyWith(soundEnabled: value);
    notifyListeners();
    await _preferencesService.saveSoundEnabled(value);
  }

  Future<void> setVibrationEnabled(bool value) async {
    _preferences = _preferences.copyWith(vibrationEnabled: value);
    notifyListeners();
    await _preferencesService.saveVibrationEnabled(value);
  }

  Future<void> setRepeatCount(int value) async {
    final normalized = NotificationPreferencesService.normalizeRepeatCount(
      value,
    );
    _preferences = _preferences.copyWith(repeatCount: normalized);
    notifyListeners();
    await _preferencesService.saveRepeatCount(normalized);
  }
}
