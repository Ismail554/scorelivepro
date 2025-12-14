import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Reusable Settings Card Container
/// Used for all settings items with consistent styling
class SettingsCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const SettingsCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: double.infinity,
      padding: padding ?? AppPadding.r16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppPadding.c12,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppPadding.c12,
        child: card,
      );
    }

    return card;
  }
}

/// Settings Section Header
class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h, top: 16.h),
      child: Text(
        title,
        style: FontManager.labelLarge(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
