import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/config/language/lanugage_provider.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/core/language_manager.dart';
import 'package:scorelivepro/widget/settings/language_card.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale? _currentLocale;

  // List of all supported languages
  final List<Locale> _languages = LanguageManager.supportedLocales;

  // Language data with English name, native name, and flag emoji
  static final Map<Locale, Map<String, String>> _languageData = {
    LanguageManager.english: {
      'english': 'English',
      'native': 'English',
      'flag': '🇬🇧',
    },
    LanguageManager.spanish: {
      'english': 'Spanish',
      'native': 'Español',
      'flag': '🇪🇸',
    },
    LanguageManager.french: {
      'english': 'French',
      'native': 'Français',
      'flag': '🇫🇷',
    },
    LanguageManager.german: {
      'english': 'German',
      'native': 'Deutsch',
      'flag': '🇩🇪',
    },
    LanguageManager.italian: {
      'english': 'Italian',
      'native': 'Italiano',
      'flag': '🇮🇹',
    },
    LanguageManager.portuguese: {
      'english': 'Portuguese',
      'native': 'Português',
      'flag': '🇵🇹',
    },
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get current locale from context after dependencies are available
    if (_currentLocale == null) {
      _currentLocale = context.locale;
    }
  }

  Future<void> _changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    setState(() {
      _currentLocale = locale;
    });

    // Change language using EasyLocalization
    await context.setLocale(locale);

    // Save language preference using SecureStorageLanguageHelper
    // Format should match what's expected in main.dart (e.g., "English", "Spanish", etc.)
    try {
      // Get the English name for the language (matching main.dart switch cases)
      final languageName = _getLanguageNameForStorage(locale);
      await SecureStorageLanguageHelper.setLanguage(languageName);
    } catch (e) {
      debugPrint("Error saving language: $e");
    }

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppStrings.language} ${AppStrings.changed}",
            style: FontManager.bodyMedium(color: AppColors.white),
          ),
          backgroundColor: AppColors.primaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Get language name in English format for storage (matching main.dart switch cases)
  String _getLanguageNameForStorage(Locale locale) {
    return _languageData[locale]?['english'] ?? 'English';
  }

  @override
  Widget build(BuildContext context) {
    // Use context.locale if _currentLocale is not yet initialized
    final currentLocale = _currentLocale ?? context.locale;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          AppStrings.language,
          style: FontManager.heading2(),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Instructional Text
          Container(
            width: double.infinity,
            padding: AppPadding.h16 + EdgeInsets.only(top: 16.h, bottom: 8.h),
            child: Text(
              "Select your preferred language for the app.",
              style: FontManager.bodyMedium(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // Language List
          Expanded(
            child: ListView.builder(
              padding: AppPadding.h16,
              itemCount: 6, // 6 languages
              itemBuilder: (context, index) {
                final locale = _languages[index];
                final data = _languageData[locale] ?? {};
                final isSelected = currentLocale == locale;

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: LanguageCard(
                    englishName: data['english'] ?? 'English',
                    nativeName: data['native'] ?? 'English',
                    flagEmoji: data['flag'] ?? '🇬🇧',
                    isSelected: isSelected,
                    onTap: () => _changeLanguage(locale),
                  ),
                );
              },
            ),
          ),

          // Bottom Message
          Container(
            width: double.maxFinite,
            margin: AppPadding.h16 + EdgeInsets.only(bottom: 42.h),
            padding: AppPadding.r16,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: AppPadding.c12,
            ),
            child: Text(
              AppStrings.langChangeAlert,
              style: FontManager.bodySmall(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
