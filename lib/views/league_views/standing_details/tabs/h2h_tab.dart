import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// H2H (Head to Head) Tab Widget
/// Displays head-to-head statistics and last meetings
class H2HTab extends StatelessWidget {
  const H2HTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h12,

          // Head to Head Record
          Text(
            "Head to Head",
            style: FontManager.heading3(
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),

          AppSpacing.h16,

          // H2H Stats
          _H2HStatsCard(),

          AppSpacing.h24,

          // Last 5 Meetings
          Text(
            "Last 5 Meetings",
            style: FontManager.heading3(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),

          AppSpacing.h16,

          // Last 5 Meetings List
          _H2HMatchItem(
            homeTeam: "Arsenal",
            awayTeam: "Man City",
            score: "1-0",
            date: "Oct 2025",
          ),
          AppSpacing.h12,
          _H2HMatchItem(
            homeTeam: "Man City",
            awayTeam: "Arsenal",
            score: "4-1",
            date: "Apr 2025",
          ),
          AppSpacing.h12,
          _H2HMatchItem(
            homeTeam: "Arsenal",
            awayTeam: "Man City",
            score: "1-3",
            date: "Feb 2025",
          ),
          AppSpacing.h12,
          _H2HMatchItem(
            homeTeam: "Man City",
            awayTeam: "Arsenal",
            score: "2-2",
            date: "Oct 2024",
          ),
          AppSpacing.h12,
          _H2HMatchItem(
            homeTeam: "Arsenal",
            awayTeam: "Man City",
            score: "0-0",
            date: "Apr 2024",
          ),

          AppSpacing.h24,
        ],
      ),
    );
  }
}

/// H2H Stats Card Widget
class _H2HStatsCard extends StatelessWidget {
  const _H2HStatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _H2HStatItem(
            value: "8",
            label: "Home Wins",
            color: AppColors.primaryColor,
          ),
          _H2HStatItem(
            value: "3",
            label: "Draws",
            color: AppColors.grey,
          ),
          _H2HStatItem(
            value: "5",
            label: "Away Wins",
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}

/// H2H Stat Item Widget
class _H2HStatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _H2HStatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: FontManager.heading1(
            fontSize: 24,
            color: color,
          ),
        ),
        AppSpacing.h4,
        Text(
          label,
          style: FontManager.bodySmall(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// H2H Match Item Widget
class _H2HMatchItem extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String score;
  final String date;

  const _H2HMatchItem({
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$homeTeam vs $awayTeam",
              style: FontManager.bodyMedium(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            score,
            style: FontManager.heading4(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.w12,
          Text(
            date,
            style: FontManager.bodySmall(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

