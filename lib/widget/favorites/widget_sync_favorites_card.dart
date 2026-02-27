import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';

/// Sync favorites card widget
class SyncFavoritesCard extends StatelessWidget {
  final VoidCallback? onLoginTap;

  const SyncFavoritesCard({
    super.key,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Cloud Icon
              Icon(
                Icons.cloud_outlined,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              // Title
              Text(
                AppLocalizations.of(context).syncYourFavorites,
                style: FontManager.labelMedium(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Description
          Text(
            AppLocalizations.of(context).syncFavoritesDescription,
            style: FontManager.bodySmall(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 16.h),
          // Login Button
          SizedBox(
            child: ElevatedButton(
              onPressed: onLoginTap,
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: AppColors.primaryColor,
              //   foregroundColor: AppColors.white,
              //   padding: EdgeInsets.symmetric(vertical: 12.h),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(8.r),
              //   ),
              //   elevation: 0,
              // ),
              child: Text(
                AppLocalizations.of(context).loginToSync,
                style: FontManager.labelMedium(
                  color: AppColors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
