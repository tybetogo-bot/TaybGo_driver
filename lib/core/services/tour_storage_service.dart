import 'package:shared_preferences/shared_preferences.dart';

class TourStorageService {
  static const String _keyTourCompleted = 'tour_completed';
  static const String _keyTourLastStage = 'tour_last_stage';
  static const String _keyTourSkipCount = 'tour_skip_count';
  static const String _keyTourCompletedDate = 'tour_completed_date';

  Future<bool> isTourCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTourCompleted) ?? false;
  }

  Future<void> setTourCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTourCompleted, completed);

    if (completed) {
      await prefs.setString(
        _keyTourCompletedDate,
        DateTime.now().toIso8601String(),
      );
    }
  }

  Future<String?> getLastTourStage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTourLastStage);
  }

  Future<void> setLastTourStage(String stage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTourLastStage, stage);
  }

  Future<int> getTourSkipCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTourSkipCount) ?? 0;
  }

  Future<void> incrementTourSkipCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getTourSkipCount();
    await prefs.setInt(_keyTourSkipCount, currentCount + 1);
  }

  Future<DateTime?> getTourCompletedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_keyTourCompletedDate);
    if (dateString != null) {
      return DateTime.tryParse(dateString);
    }
    return null;
  }

  Future<void> resetTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTourCompleted);
    await prefs.remove(_keyTourLastStage);
    await prefs.remove(_keyTourCompletedDate);
    await prefs.remove(_keyTourSkipCount);
  }

  Future<void> clearAllTourData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTourCompleted);
    await prefs.remove(_keyTourLastStage);
    await prefs.remove(_keyTourSkipCount);
    await prefs.remove(_keyTourCompletedDate);
  }
}
