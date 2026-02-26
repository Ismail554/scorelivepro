import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';

import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/core/language_manager.dart';
import 'package:scorelivepro/provider/language_provider.dart';
import 'package:scorelivepro/widget/settings/language_card.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // List of all supported languages
  final List<Locale> _languages = LanguageManager.supportedLocales;

  // Language data with English name, native name, and flag emoji
  final Map<Locale, Map<String, String>> _languageData = {
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

  Future<void> _changeLanguage(Locale locale) async {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    if (provider.currentLocale == locale) return;

    await provider.changeLanguage(locale);

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context).language} ${AppLocalizations.of(context).changed}",
            style: FontManager.bodyMedium(color: AppColors.white),
          ),
          backgroundColor: AppColors.primaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get Locale from Provider
    final currentLocale = Provider.of<LanguageProvider>(context).currentLocale;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).language,
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
              AppLocalizations.of(context).selectLanguage,
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
              AppLocalizations.of(context).langChangeAlert,
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
