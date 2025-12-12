import 'package:flutter/material.dart';

/// Language Manager for ScoreLivePro
/// Supports 6 languages: English, Spanish, French, German, Italian, Portuguese
/// Note: Locales match translation files in assets/translations/
class LanguageManager {
  // Supported languages (matching translation file names)
  static const Locale english = Locale('en', 'US');
  static const Locale spanish = Locale('sp', 'ES'); // Note: 'sp' not 'es'
  static const Locale french = Locale('fr', 'FR');
  static const Locale german = Locale('de', 'GM'); // Note: 'GM' not 'DE'
  static const Locale italian = Locale('it', 'IT');
  static const Locale portuguese = Locale('pt', 'PR'); // Note: 'PR' not 'BR'

  // List of supported locales
  static const List<Locale> supportedLocales = [
    english,
    spanish,
    french,
    german,
    italian,
    portuguese,
  ];

  // Language names for display
  static final Map<Locale, String> languageNames = {
    english: 'English',
    spanish: 'Español',
    french: 'Français',
    german: 'Deutsch',
    italian: 'Italiano',
    portuguese: 'Português',
  };

  // Language codes (primary language code)
  static const String englishCode = 'en';
  static const String spanishCode = 'sp'; // Note: 'sp' not 'es'
  static const String frenchCode = 'fr';
  static const String germanCode = 'de';
  static const String italianCode = 'it';
  static const String portugueseCode = 'pt';

  /// Get language name by locale
  static String getLanguageName(Locale locale) {
    return languageNames[locale] ?? 'English';
  }

  /// Get locale by language code
  static Locale getLocaleByCode(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return english;
      case 'sp':
      case 'es': // Support both 'sp' and 'es' for Spanish
        return spanish;
      case 'fr':
        return french;
      case 'de':
        return german;
      case 'it':
        return italian;
      case 'pt':
        return portuguese;
      default:
        return english;
    }
  }

  /// Get locale by full locale string (e.g., 'en-US', 'sp-ES')
  static Locale getLocaleByString(String localeString) {
    final parts = localeString.split('-');
    if (parts.length >= 2) {
      return Locale(parts[0], parts[1]);
    } else if (parts.length == 1) {
      return getLocaleByCode(parts[0]);
    }
    return english;
  }

  /// Check if locale is RTL (Right-to-Left)
  /// Note: None of the current languages are RTL, but kept for future use
  static bool isRTL(Locale locale) {
    // Currently no RTL languages in the 6 supported languages
    return false;
  }

  /// Get text direction for locale
  static TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Get language name by language code
  static String getLanguageNameByCode(String code) {
    final locale = getLocaleByCode(code);
    return getLanguageName(locale);
  }
}
