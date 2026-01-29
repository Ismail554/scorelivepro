import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Team browse card widget for Browse Teams screen
class TeamBrowseCard extends StatelessWidget {
  final String teamName;
  final String leagueName;
  final bool isFavorited;

  final VoidCallback? onFavoriteToggle;
  final String? logoUrl;

  const TeamBrowseCard({
    super.key,
    required this.teamName,
    required this.leagueName,
    this.isFavorited = false,
    this.onFavoriteToggle,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyE8,
          width: 1.w,
        ),
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
          // Team Logo (circular)
          Container(
            width: 48.w,
            height: 48.w,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.greyE8.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: logoUrl != null
                ? Image.network(
                    logoUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      IconAssets.soccer_icon,
                      fit: BoxFit.contain,
                    ),
                  )
                : Image.asset(
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

          // Favorite/Add Button
          if (onFavoriteToggle != null)
            GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isFavorited
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  isFavorited ? Icons.favorite : Icons.add,
                  color: isFavorited ? AppColors.primaryColor : AppColors.grey,
                  size: 24.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
