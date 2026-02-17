import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Favorite team card widget
class FavoriteTeamCard extends StatelessWidget {
  final String teamName;
  final String leagueName;
  final bool notificationsEnabled;
  final VoidCallback? onNotificationToggle;
  final VoidCallback? onDelete;

  const FavoriteTeamCard({
    super.key,
    required this.teamName,
    required this.leagueName,
    this.notificationsEnabled = true,
    this.onNotificationToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey.shade100, width: 1.w),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Team Logo (circular placeholder)
          Container(
            width: 48.w,
            height: 48.w,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.greyE8.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              IconAssets.soccer_icon,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: 16.w),

          // Team Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  style: FontManager.teamName(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  leagueName,
                  style: FontManager.leagueName(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

         
          SizedBox(width: 8.w),

          // Delete Icon
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.delete_outline,
                color: AppColors.grey,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
