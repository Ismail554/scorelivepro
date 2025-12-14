import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/settings/language_selection_screen.dart';
import 'package:scorelivepro/widget/settings/settings_card.dart';
import 'package:scorelivepro/widget/settings/unified_settings_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          AppStrings.settings,
          style: FontManager.heading2(),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: AppPadding.h16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ACCOUNT Section
            SettingsSectionHeader(title: AppStrings.account),
            UnifiedSettingsItem(
              icon: Icons.login,
              title: AppStrings.loginSignUp,
              subtitle: AppStrings.syncFavorites,
              onTap: () {
                // TODO: Navigate to login/signup screen
              },
            ),

            AppSpacing.h24,

            // PREFERENCES Section
            SettingsSectionHeader(title: AppStrings.preferences),

            // Notifications Toggle
            UnifiedSettingsItem(
              icon: Icons.notifications_outlined,
              title: AppStrings.notifications,
              subtitle: _notificationsEnabled
                  ? AppStrings.enabled
                  : AppStrings.disabled,
              toggleValue: _notificationsEnabled,
              onToggleChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),

            AppSpacing.h12,

            // Language
            UnifiedSettingsItem(
              icon: Icons.language_outlined,
              title: AppStrings.language,
              subtitle: AppStrings.english, // TODO: Get current language
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSelectionScreen(),
                  ),
                );
              },
            ),

            AppSpacing.h24,

            // ABOUT Section
            SettingsSectionHeader(title: AppStrings.aboutSection),

            // App Info
            UnifiedSettingsItem(
              icon: Icons.info_outline,
              title: AppStrings.appInfo,
              subtitle: AppStrings.versionNumber,
              onTap: () {
                // TODO: Show app info dialog
              },
            ),

            AppSpacing.h12,

            // Privacy & Terms
            UnifiedSettingsItem(
              icon: Icons.lock_outline,
              title: AppStrings.privacyAndTerms,
              onTap: () {
                // TODO: Navigate to privacy & terms
              },
            ),

            AppSpacing.h40,

            // App Branding
            _buildAppBranding(),

            AppSpacing.h24,

            // Disclaimer
            _buildDisclaimer(),

            AppSpacing.h32,
          ],
        ),
      ),
    );
  }

  /// App Branding Widget
  Widget _buildAppBranding() {
    return Center(
      child: Column(
        children: [
          // App Icon/Logo
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: AppPadding.c12,
            ),
            child: Image.asset(IconAssets.app_logo),
          ),

          SizedBox(height: 16.h),

          // App Name
          Text(
            AppStrings.appName,
            style: FontManager.heading2(
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 8.h),

          // Tagline
          Text(
            "Real-Time Football Scores & News",
            style: FontManager.bodyMedium(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          // Copyright
          Text(
            "© 2025 ScoreLivePRO",
            style: FontManager.bodySmall(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  /// Disclaimer Widget
  Widget _buildDisclaimer() {
    return SettingsCard(
      padding: AppPadding.r16,
      child: Text(
        "ScoreLivePRO is not meant for collecting PII or securing sensitive data. This app is designed for entertainment and informational purposes only.",
        style: FontManager.bodySmall(
          fontSize: 12,
          color: AppColors.textTertiary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
