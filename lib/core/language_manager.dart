import 'package:flutter/material.dart';

/// Language Manager for ScoreLivePro
/// Supports 6 languages: English, Spanish, French, Arabic, Portuguese, German
class LanguageManager {
  // Supported languages
  static const Locale english = Locale('en', 'US');
  static const Locale spanish = Locale('es', 'ES');
  static const Locale french = Locale('fr', 'FR');
  static const Locale arabic = Locale('ar', 'SA');
  static const Locale portuguese = Locale('pt', 'BR');
  static const Locale german = Locale('de', 'DE');

  // List of supported locales
  static const List<Locale> supportedLocales = [
    english,
    spanish,
    french,
    arabic,
    portuguese,
    german,
  ];

  // Language names for display
  static final Map<Locale, String> languageNames = {
    english: 'English',
    spanish: 'Español',
    french: 'Français',
    arabic: 'العربية',
    portuguese: 'Português',
    german: 'Deutsch',
  };

  // Language codes
  static const String englishCode = 'en';
  static const String spanishCode = 'es';
  static const String frenchCode = 'fr';
  static const String arabicCode = 'ar';
  static const String portugueseCode = 'pt';
  static const String germanCode = 'de';

  /// Get language name by locale
  static String getLanguageName(Locale locale) {
    return languageNames[locale] ?? 'English';
  }

  /// Get locale by language code
  static Locale getLocaleByCode(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return english;
      case 'es':
        return spanish;
      case 'fr':
        return french;
      case 'ar':
        return arabic;
      case 'pt':
        return portuguese;
      case 'de':
        return german;
      default:
        return english;
    }
  }

  /// Check if locale is RTL (Right-to-Left)
  static bool isRTL(Locale locale) {
    return locale.languageCode == arabicCode;
  }

  /// Get text direction for locale
  static TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? TextDirection.rtl : TextDirection.ltr;
  }
}
