import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Premium Notification Feature Card
/// Similar to SponsoredAdCard but customized for notifications
class PremiumNotificationCard extends StatelessWidget {
  final VoidCallback? onUpgradeTap;

  const PremiumNotificationCard({
    super.key,
    this.onUpgradeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: AppPadding.r20,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: AppPadding.c16,
      ),
      child: Stack(
        children: [
          // Background bell graphic (positioned on right)
          Positioned(
            right: -10.w,
            bottom: -30.h,
            child: Opacity(
              opacity: 0.3,
              child: Icon(
                Icons.notifications_active,
                size: 120.sp,
                color: AppColors.white,
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Feature Label
              Text(
                'PREMIUM FEATURE',
                style: FontManager.labelSmall(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: 10,
                ),
              ),

              SizedBox(height: 8.h),

              // Title
              Text(
                'Smart Notifications',
                style: FontManager.heading2(
                  color: AppColors.white,
                  fontSize: 24,
                ),
              ),

              SizedBox(height: 8.h),

              // Description
              Text(
                'Get personalized alerts for your favorite teams with premium notifications',
                style: FontManager.bodyMedium(
                  color: AppColors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 16.h),

              // Upgrade Now Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: onUpgradeTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Upgrade Now',
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
