import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Match Header Info Widget - Reusable component for match details
class MatchHeaderInfo extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String score;
  final String? status;
  final String dateTime;
  final String venue;
  final Color statusColor;

  const MatchHeaderInfo({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    this.status, // Not required
    required this.dateTime,
    required this.venue,
    this.statusColor = AppColors.finishedMatch,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),

          // --- Updated Section: Conditional Status Badge ---
          if (status != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                status!, // Using ! because we checked for null above
                style: FontManager.labelMedium(
                  fontSize: 12,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
          // ------------------------------------------------

          // Teams and Score
          _buildScoreboard(),

          // SizedBox(height: 6.h),

          // Date and Time
          Text(
            dateTime,
            style: FontManager.bodySmall(
              fontSize: 12,
              color: AppColors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),

          // SizedBox(height: 4.h),

          // Venue
          Text(
            venue,
            style: FontManager.bodySmall(
              fontSize: 12,
              color: AppColors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),

          // SizedBox(height: 8.h),
        ],
      ),
    );
  }

  // ... rest of your _buildScoreboard and _buildTeamInfo methods remain the same
  Widget _buildScoreboard() {
    return Padding(
      padding: AppPadding.h24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildTeamInfo(homeTeam)),
          Align(
            alignment: Alignment.center,
            child: Expanded(
              child: Text(
                score,
                style: FontManager.matchScore(
                  fontSize: 34.sp,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(child: _buildTeamInfo(awayTeam)),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(String teamName) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 48.w,
            height: 48.w,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.greyE8.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              IconAssets.soccer_icon,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          teamName,
          style: FontManager.bodyMedium(
            fontSize: 14,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
