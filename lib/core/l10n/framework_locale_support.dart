import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

class FrameworkLocaleSupport {
  static const Map<String, Locale> _frameworkFallbacks = {'lb': Locale('de')};

  static bool hasFrameworkFallback(Locale locale) {
    return _frameworkFallbacks.containsKey(locale.languageCode);
  }

  static Locale frameworkLocale(Locale locale) {
    return _frameworkFallbacks[locale.languageCode] ?? locale;
  }

  static String dateFormattingLocale(Locale locale) {
    final requestedLocale = locale.toString();
    final verifiedRequestedLocale = intl.Intl.verifiedLocale(
      requestedLocale,
      intl.DateFormat.localeExists,
      onFailure: (_) => null,
    );
    if (verifiedRequestedLocale != null) {
      return verifiedRequestedLocale;
    }

    final fallbackLocale = frameworkLocale(locale).toString();
    return intl.Intl.verifiedLocale(
          fallbackLocale,
          intl.DateFormat.localeExists,
          onFailure: (_) => 'en',
        ) ??
        'en';
  }
}

class FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return FrameworkLocaleSupport.hasFrameworkFallback(locale);
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return GlobalMaterialLocalizations.delegate.load(
      FrameworkLocaleSupport.frameworkLocale(locale),
    );
  }

  @override
  bool shouldReload(FallbackMaterialLocalizationsDelegate old) => false;
}

class FallbackWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const FallbackWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return FrameworkLocaleSupport.hasFrameworkFallback(locale);
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    return GlobalWidgetsLocalizations.delegate.load(
      FrameworkLocaleSupport.frameworkLocale(locale),
    );
  }

  @override
  bool shouldReload(FallbackWidgetsLocalizationsDelegate old) => false;
}

class FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return FrameworkLocaleSupport.hasFrameworkFallback(locale);
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return GlobalCupertinoLocalizations.delegate.load(
      FrameworkLocaleSupport.frameworkLocale(locale),
    );
  }

  @override
  bool shouldReload(FallbackCupertinoLocalizationsDelegate old) => false;
}
