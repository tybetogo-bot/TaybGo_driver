import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/kb_models.dart';

class KBService {
  KnowledgeBase? _cachedKB;
  String? _cachedLocale;

  /// Load knowledge base for the given locale
  /// Caches the result to avoid repeated loading
  Future<KnowledgeBase> loadKnowledgeBase(String locale) async {
    // Return cached if same locale
    if (_cachedKB != null && _cachedLocale == locale) {
      return _cachedKB!;
    }

    try {
      // Load JSON file for the locale
      final jsonString = await rootBundle.loadString(
        'assets/data/knowledge_base_$locale.json',
      );

      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final kb = KnowledgeBase.fromJson(jsonData);

      // Cache the result
      _cachedKB = kb;
      _cachedLocale = locale;

      return kb;
    } catch (e) {
      // Fallback to English if locale file not found
      if (locale != 'en') {
        return loadKnowledgeBase('en');
      }

      // If English also fails, return empty knowledge base
      return KnowledgeBase(categories: []);
    }
  }

  /// Clear cache (useful when changing language)
  void clearCache() {
    _cachedKB = null;
    _cachedLocale = null;
  }

  /// Get knowledge base for current locale
  /// Returns cached version if available
  KnowledgeBase? getCached() {
    return _cachedKB;
  }
}
