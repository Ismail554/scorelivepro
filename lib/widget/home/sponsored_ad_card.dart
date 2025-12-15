import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Sponsored ad card widget for home screen
class SponsoredAdCard extends StatelessWidget {
  final VoidCallback? onTryFreeTap;

  const SponsoredAdCard({
    super.key,
    this.onTryFreeTap,
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
          // Background soccer ball graphic (placeholder)
          Positioned(
            right: -20.w,
            bottom: -20.h,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.sports_soccer,
                size: 120.sp,
                color: AppColors.white,
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sponsored label
              Text(
                'SPONSORED',
                style: FontManager.labelSmall(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 8.h),
              // Title with icon
              Row(
                children: [
                  Icon(
                    Icons.bolt,
                    color: AppColors.warning,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'PowerPlay Sports+',
                    style: FontManager.heading3(
                      color: AppColors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Description
              Text(
                'Watch Live Matches in HD • Ad-Free Experience',
                style: FontManager.bodySmall(
                  color: AppColors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16.h),
              // Try Free button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onTryFreeTap,
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
                      'Try Free',
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
