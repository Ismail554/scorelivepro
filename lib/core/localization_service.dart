import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_manager.dart';

/// Localization Service for ScoreLivePro
/// Manages app language and locale settings
class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  Locale _currentLocale = LanguageManager.english;

  /// Get current locale
  Locale get currentLocale => _currentLocale;

  /// Get current language code
  String get currentLanguageCode => _currentLocale.languageCode;

  /// Check if current language is RTL
  bool get isRTL => LanguageManager.isRTL(_currentLocale);

  /// Get text direction for current locale
  TextDirection get textDirection =>
      LanguageManager.getTextDirection(_currentLocale);

  /// Initialize localization service
  /// Loads saved language preference or uses device locale
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey);

      if (savedLanguageCode != null) {
        _currentLocale = LanguageManager.getLocaleByCode(savedLanguageCode);
      } else {
        // Use device locale if supported, otherwise default to English
        final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
        if (LanguageManager.supportedLocales.contains(deviceLocale)) {
          _currentLocale = deviceLocale;
        } else {
          // Check if language code matches (without country code)
          final matchingLocale = LanguageManager.supportedLocales.firstWhere(
            (locale) => locale.languageCode == deviceLocale.languageCode,
            orElse: () => LanguageManager.english,
          );
          _currentLocale = matchingLocale;
        }
      }

      notifyListeners();
    } catch (e) {
      // If error, use default locale
      _currentLocale = LanguageManager.english;
    }
  }

  /// Change app language
  Future<void> changeLanguage(Locale locale) async {
    if (!LanguageManager.supportedLocales.contains(locale)) {
      return;
    }

    _currentLocale = locale;
    notifyListeners();

    // Save preference
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Change language by code
  Future<void> changeLanguageByCode(String languageCode) async {
    final locale = LanguageManager.getLocaleByCode(languageCode);
    await changeLanguage(locale);
  }

  /// Get all supported locales
  List<Locale> get supportedLocales => LanguageManager.supportedLocales;

  /// Get language name for current locale
  String get currentLanguageName =>
      LanguageManager.getLanguageName(_currentLocale);

  /// Get language name for a specific locale
  String getLanguageName(Locale locale) =>
      LanguageManager.getLanguageName(locale);
}
