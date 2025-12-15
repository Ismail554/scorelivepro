import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/home_views/live_mathches/live_match_details_screen.dart';

/// Match status enum
enum MatchStatus {
  live,
  halfTime,
  upcoming,
  finished,
}

class MatchCard extends StatelessWidget {
  final String leagueName;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String timeInfo; // e.g., "Today, 18:30" or "Live"
  final MatchStatus status;
  final VoidCallback? onTap; // Keep this as an optional parameter

  const MatchCard({
    super.key,
    required this.leagueName,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    required this.timeInfo,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = status == MatchStatus.live || status == MatchStatus.halfTime;
    final isUpcoming = status == MatchStatus.upcoming;
    final isFinished = status == MatchStatus.finished;

    // Parse timeInfo for upcoming and finished matches
    String dateText = '';
    String timeBadgeText = timeInfo;

    if ((isUpcoming || isFinished) && timeInfo.contains(',')) {
      final parts = timeInfo.split(',');
      dateText = parts[0].trim(); // "Today" or "Yesterday"
      if (parts.length > 1) {
        timeBadgeText = parts[1].trim(); // "18:30"
      }
    } else if (isFinished && !timeInfo.contains(',')) {
      // For finished matches without comma, use the whole string as date
      dateText = timeInfo;
      timeBadgeText = 'FT';
    }

    return GestureDetector(
      // FIX IS HERE: Check if onTap is provided, otherwise use default navigation
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LiveMatchDetailsScreen()),
            );
          },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.grey.shade400,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: For live matches, show yellow dot + LIVE + league name
            if (isLive) ...[
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'LIVE',
                    style: FontManager.labelMedium(
                      color: AppColors.warning,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    leagueName,
                    style: FontManager.leagueName(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                height: 1.h,
                color: AppColors.warning,
              ),
              SizedBox(height: 16.h),
            ] else ...[
              // Just league name for upcoming matches
              Text(
                leagueName,
                style: FontManager.leagueName(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Home Team Row
            _buildTeamRow(homeTeam, homeScore),

            SizedBox(height: 12.h),

            // Away Team Row
            _buildTeamRow(awayTeam, awayScore),

            SizedBox(height: 12.h),

            // Divider
            Divider(
              color: AppColors.greyE8,
              thickness: 1.h,
              height: 1.h,
            ),

            if (!isLive) SizedBox(height: 12.h),

            AppSpacing.h10,

            // Footer: Time info and badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Minute for live, date for upcoming/finished
                Text(
                  isLive ? timeInfo : dateText,
                  style: FontManager.bodySmall(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
                // Right side: Status badge
                _buildStatusBadge(isFinished ? 'FT' : timeBadgeText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to build a row: "Team Name ......... Score"
  Widget _buildTeamRow(String teamName, int? score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            teamName,
            style: FontManager.heading4(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          score != null ? score.toString() : '-',
          style: FontManager.heading4(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  /// Build status badge based on match status
  Widget _buildStatusBadge(String badgeText) {
    switch (status) {
      case MatchStatus.live:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.warning,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'LIVE',
            style: FontManager.labelMedium(
              color: AppColors.white,
              fontSize: 12.sp,
            ),
          ),
        );
      case MatchStatus.halfTime:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'HT',
            style: FontManager.labelMedium(
              color: AppColors.white,
              fontSize: 12.sp,
            ),
          ),
        );
      case MatchStatus.upcoming:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.greyE8,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            badgeText,
            style: FontManager.bodySmall(
              color: AppColors.textPrimary,
              fontSize: 12.sp,
            ),
          ),
        );
      case MatchStatus.finished:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.finishedMatch,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'FT',
            style: FontManager.labelMedium(
              color: AppColors.white,
              fontSize: 12.sp,
            ),
          ),
        );
    }
  }
}
