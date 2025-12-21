import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// League icon type
enum LeagueIconType {
  trophy, // Gold trophy
  medal, // Silver medal with number
  flag, // Country flag
}

/// League card widget
class LeagueCard extends StatelessWidget {
  final String leagueName;
  final String countryOrRegion;
  final LeagueIconType iconType;
  final String? iconLabel; // For medal type (e.g., "2")
  final String? flagEmoji; // For flag type
  final VoidCallback? onTap;

  const LeagueCard({
    super.key,
    required this.leagueName,
    required this.countryOrRegion,
    required this.iconType,
    this.iconLabel,
    this.flagEmoji,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // League Icon
            _buildIcon(),

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
                  Text(
                    countryOrRegion,
                    style: FontManager.leagueName(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Right Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (iconType) {
      case LeagueIconType.trophy:
        return Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.greyE8,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.emoji_events,
            color: AppColors.warning, // Gold color
            size: 24.sp,
          ),
        );
      case LeagueIconType.medal:
        return Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.greyE8,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.military_tech,
                color: AppColors.grey, // Silver color
                size: 28.sp,
              ),
              if (iconLabel != null)
                Positioned(
                  bottom: 10.h,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      iconLabel!,
                      style: FontManager.labelSmall(
                        color: AppColors.textPrimary,
                        fontSize: 10,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
        );
      case LeagueIconType.flag:
        return Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.greyE8,
            shape: BoxShape.circle,
          ),
          child: flagEmoji != null
              ? Center(
                  child: Text(
                    flagEmoji!,
                    style: TextStyle(fontSize: 24.sp),
                  ),
                )
              : Icon(
                  Icons.flag,
                  color: AppColors.textSecondary,
                  size: 24.sp,
                ),
        );
    }
  }
}
