import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Favorite league card widget
class FavoriteLeagueCard extends StatelessWidget {
  final String leagueName;
  final String countryName;
  final String? countryFlag; // Can be emoji or asset path
  final String? logoUrl;
  final VoidCallback? onDelete;

  const FavoriteLeagueCard({
    super.key,
    required this.leagueName,
    required this.countryName,
    this.countryFlag,
    this.logoUrl,
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
          // League Logo (circular placeholder with trophy)
          Container(
            width: 48.w,
            height: 48.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.greyE8,
              shape: BoxShape.circle,
            ),
            child: logoUrl != null
                ? Image.network(
                    logoUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.emoji_events,
                        color: AppColors.warning,
                        size: 24.sp,
                      );
                    },
                  )
                : Icon(
                    Icons.emoji_events,
                    color: AppColors.warning,
                    size: 24.sp,
                  ),
          ),

          SizedBox(width: 16.w),

          // League Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leagueName,
                  style: FontManager.teamName(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    if (countryFlag != null) ...[
                      Text(
                        countryFlag!,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(width: 6.w),
                    ],
                    Text(
                      countryName,
                      style: FontManager.leagueName(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

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
