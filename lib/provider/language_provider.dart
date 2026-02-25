import 'package:flutter/material.dart';
import 'package:scorelivepro/config/language/lanugage_provider.dart';
import 'package:scorelivepro/core/language_manager.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = LanguageManager.english;

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final savedLanguage = await SecureStorageLanguageHelper.getLanguage();
      if (savedLanguage != null) {
        _currentLocale =
            LanguageManager.getLocaleByCode(_getCodeFromName(savedLanguage));
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading language: $e");
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;
    notifyListeners();

    try {
      final languageName = LanguageManager.getLanguageName(locale);
      await SecureStorageLanguageHelper.setLanguage(languageName);
    } catch (e) {
      debugPrint("Error saving language: $e");
    }
  }

  String _getCodeFromName(String name) {
    switch (name) {
      case "English":
        return LanguageManager.englishCode;
      case "Spanish":
        return LanguageManager.spanishCode;
      case "French":
        return LanguageManager.frenchCode;
      case "German":
        return LanguageManager.germanCode;
      case "Italian":
        return LanguageManager.italianCode;
      case "Portuguese":
        return LanguageManager.portugueseCode;
      default:
        return LanguageManager.englishCode;
    }
  }
}
