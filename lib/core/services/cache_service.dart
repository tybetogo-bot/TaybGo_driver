import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  /// Clear all cached data and saved preferences
  static Future<void> clearAllCache() async {
    try {
      debugPrint('[CacheService] === CLEARING ALL CACHE ===');

      final prefs = await SharedPreferences.getInstance();

      // Get all keys before clearing
      final allKeys = prefs.getKeys();
      debugPrint('[CacheService] Found ${allKeys.length} keys to clear');

      // Clear all preferences
      await prefs.clear();
      debugPrint('[CacheService] All SharedPreferences cleared');

      debugPrint('[CacheService] === CACHE CLEARING COMPLETE ===');
    } catch (e) {
      debugPrint('[CacheService] Error clearing cache: $e');
      rethrow;
    }
  }

  /// Clear specific cache keys (if needed for selective clearing)
  static Future<void> clearCacheKeys(List<String> keys) async {
    try {
      debugPrint('[CacheService] Clearing specific cache keys: $keys');

      final prefs = await SharedPreferences.getInstance();
      for (final key in keys) {
        await prefs.remove(key);
      }

      debugPrint('[CacheService] Cleared ${keys.length} cache keys');
    } catch (e) {
      debugPrint('[CacheService] Error clearing cache keys: $e');
      rethrow;
    }
  }
}
