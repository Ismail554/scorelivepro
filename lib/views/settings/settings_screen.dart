import 'package:flutter/material.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            title: AppStrings.profile,
            icon: Icons.person_outline,
            onTap: () {},
          ),
          _buildSettingsSection(
            title: AppStrings.language,
            icon: Icons.language_outlined,
            onTap: () {},
          ),
          _buildSettingsSection(
            title: AppStrings.notificationSettings,
            icon: Icons.notifications_outlined,
            onTap: () {},
          ),
          _buildSettingsSection(
            title: AppStrings.about,
            icon: Icons.info_outline,
            onTap: () {},
          ),
          _buildSettingsSection(
            title: AppStrings.help,
            icon: Icons.help_outline,
            onTap: () {},
          ),
          _buildSettingsSection(
            title: AppStrings.signOut,
            icon: Icons.logout,
            onTap: () {},
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.textPrimary,
      ),
      title: Text(
        title,
        style: FontManager.bodyMedium(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.grey,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
