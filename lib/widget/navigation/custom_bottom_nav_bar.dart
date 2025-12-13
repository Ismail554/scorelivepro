import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Custom Bottom Navigation Bar matching Figma design
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.sports_soccer,
                label: AppStrings.matches,
                index: 0,
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                icon: Icons.star_border,
                label: AppStrings.favorites,
                index: 1,
                isSelected: currentIndex == 1,
              ),
              _buildNavItem(
                icon: Icons.newspaper_outlined,
                label: AppStrings.news,
                index: 2,
                isSelected: currentIndex == 2,
              ),
              _buildNavItem(
                icon: Icons.emoji_events_outlined,
                label: AppStrings.leagues,
                index: 3,
                isSelected: currentIndex == 3,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                label: AppStrings.settings,
                index: 4,
                isSelected: currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    final color = isSelected ? AppColors.primaryColor : AppColors.grey;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon - filled for selected, outlined for unselected
            Icon(
              isSelected ? _getFilledIcon(icon) : icon,
              size: 24.sp,
              color: color,
            ),
            SizedBox(height: 4.h),
            // Label
            Text(
              label,
              style: FontManager.labelSmall(
                fontSize: 12,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Get filled icon variant for selected state
  IconData _getFilledIcon(IconData outlinedIcon) {
    switch (outlinedIcon) {
      case Icons.sports_soccer:
        return Icons.sports_soccer;
      case Icons.star_border:
        return Icons.star;
      case Icons.newspaper_outlined:
        return Icons.newspaper;
      case Icons.emoji_events_outlined:
        return Icons.emoji_events;
      case Icons.settings_outlined:
        return Icons.settings;
      default:
        return outlinedIcon;
    }
  }
}
