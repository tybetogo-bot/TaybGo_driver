import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'locale';

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('de'),
    Locale('fr'),
    Locale('ar'),
    Locale('lb'),
    Locale('it'),
    Locale('nl'),
    Locale('sv'),
    Locale('nb'),
    Locale('da'),
    Locale('fi'),
  ];

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey) ?? 'en';
    _locale = Locale(localeCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      case 'lb':
        return 'Lëtzebuergesch';
      case 'it':
        return 'Italiano';
      case 'nl':
        return 'Nederlands';
      case 'sv':
        return 'Svenska';
      case 'nb':
        return 'Norsk';
      case 'da':
        return 'Dansk';
      case 'fi':
        return 'Suomi';
      default:
        return 'English';
    }
  }
}
