import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/settings/settings_card.dart';

/// Unified Settings Item Widget
/// Handles all types of settings items: regular, toggle, and custom trailing
class UnifiedSettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;

  // Toggle specific
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  // Custom trailing widget (arrow, checkmark, etc.)
  final Widget? trailing;

  // Show default arrow if not toggle and no custom trailing
  final bool showArrow;

  const UnifiedSettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.toggleValue,
    this.onToggleChanged,
    this.trailing,
    this.showArrow = true,
  }) : assert(
          (toggleValue == null && onToggleChanged == null) ||
              (toggleValue != null && onToggleChanged != null),
          'Both toggleValue and onToggleChanged must be provided together',
        );

  @override
  Widget build(BuildContext context) {
    // Determine trailing widget
    Widget? trailingWidget;

    if (toggleValue != null && onToggleChanged != null) {
      // Toggle switch
      trailingWidget = Switch(
        value: toggleValue!,
        onChanged: onToggleChanged,
        activeThumbColor: AppColors.primaryColor,
      );
    } else if (trailing != null) {
      // Custom trailing widget
      trailingWidget = trailing;
    } else if (showArrow) {
      // Default arrow
      trailingWidget = Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: AppColors.grey,
      );
    }

    return SettingsCard(
      onTap: toggleValue == null ? onTap : null, // Disable tap if toggle
      child: Row(
        children: [
          // Icon
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primaryColor).withValues(alpha: 0.1),
              borderRadius: AppPadding.c8,
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primaryColor,
              size: 20.sp,
            ),
          ),

          SizedBox(width: 12.w),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontManager.bodyMedium(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle!,
                    style: FontManager.bodySmall(
                      fontSize: 14,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Trailing Widget (arrow, toggle, etc.)
          if (trailingWidget != null) ...[
            SizedBox(width: 8.w),
            trailingWidget,
          ],
        ],
      ),
    );
  }
}
