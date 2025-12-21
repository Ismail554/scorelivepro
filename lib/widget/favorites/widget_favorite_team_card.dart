import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(
          horizontal: 16.w, vertical: 12.h), // Padding adjust korlam
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
            16.r), // Corner gula ektu beshi round, like the image
        border: Border.all(
          color: AppColors
              .greyE8, // Grey outline border (Ensure you have this color)
          width: 1.5.w, // Ektu visible thin line
        ),
      ),
      child: Row(
        children: [
          // 1. Team Logo
          Container(
            width: 48.w,
            height: 48.h, // Square Container keeps it circular
            padding: EdgeInsets.all(
                12.w), // 🔥 Magic Here! Padding controls the inner image size
            decoration: BoxDecoration(
              color: AppColors.greyE8.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              IconAssets.soccer_icon,
              fit: BoxFit.contain, // Image won't be cut off
            ),
          ),
          // Icon(
          //   Icons.sports_soccer,
          //   color: AppColors.textPrimary, // Logo should be dark
          //   size: 24.sp,
          // ),

          SizedBox(width: 16.w),

          // 2. Team Info (Name & League)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  style: FontManager.teamName(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  leagueName,
                  style: FontManager.leagueName(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

          // 3. Notification Button (The Orange Box)
          GestureDetector(
            onTap: onNotificationToggle,
            child: Container(
              width: 40.w, // Fixed size for clean square look
              height: 40.w,
              decoration: BoxDecoration(
                // Logic: Enabled hole Orange BG, Disabled hole Grey BG
                color: notificationsEnabled
                    ? const Color(0xFFFFF1EB) // Light Orange BG (Match Image)
                    : AppColors.greyE8,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                notificationsEnabled
                    ? Icons
                        .notifications_none_outlined // Outlined looks cleaner
                    : Icons.notifications_off_outlined,
                color: notificationsEnabled
                    ? const Color(0xFFFF6B00) // Deep Orange Icon
                    : AppColors.grey,
                size: 20.sp,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // 4. Delete Icon
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 40.w,
              height: 40.w,
              color: Colors.transparent, // Hitbox baranor jonno
              child: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.textSecondary, // Grey color like image
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
