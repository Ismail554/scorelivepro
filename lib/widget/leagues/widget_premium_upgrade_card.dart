import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Premium upgrade card widget for leagues screen
class PremiumUpgradeCard extends StatelessWidget {
  final VoidCallback? onUpgradeTap;

  const PremiumUpgradeCard({
    super.key,
    this.onUpgradeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          // Background trophy graphic
          Positioned(
            right: -10.w,
            bottom: -10.h,
            child: Opacity(
              opacity: 0.2,
              child: Icon(
                Icons.emoji_events,
                size: 120.sp,
                color: AppColors.warning,
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sponsored label
              Text(
                AppStrings.sponserd,
                style: FontManager.labelSmall(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 12.h),
              // Title
              Text(
                'Get Premium Features',
                style: FontManager.heading3(
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8.h),
              // Description
              Text(
                'Ad-free experience, live notifications & more',
                style: FontManager.bodySmall(
                  color: AppColors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16.h),
              // Upgrade Button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onUpgradeTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      AppStrings.upgradeNow,
                      style: FontManager.labelMedium(
                        color: AppColors.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
