import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/league_views/standing_details/models/team_standings_data.dart';

/// Overview Tab Widget
/// Displays team overview, stats cards, and recent matches
class OverviewTab extends StatelessWidget {
  final TeamStandingsData teamData;

  const OverviewTab({
    super.key,
    required this.teamData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h12,

          // Team Overview Title
          Text(
            "Team Overview",
            style: FontManager.heading3(
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),

          AppSpacing.h16,

          // Summary Text
          Text(
            "${teamData.teamName} is currently ranked #${teamData.rank} in the Premier League with ${teamData.points} points. The team has played ${teamData.played} matches, winning ${teamData.wins}, drawing ${teamData.draws}, and losing ${teamData.losses}. They have scored ${teamData.goalsFor} goals and conceded ${teamData.goalsAgainst}, with a goal difference of ${teamData.goalDifference > 0 ? '+' : ''}${teamData.goalDifference}.",
            style: FontManager.bodyMedium(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

          AppSpacing.h24,

          // Summary Stats Cards
          Row(
            children: [
              Expanded(
                child: _SummaryStatCard(
                  value: "${teamData.wins}",
                  label: "Wins",
                  color: AppColors.success,
                ),
              ),
              AppSpacing.w12,
              Expanded(
                child: _SummaryStatCard(
                  value: "${teamData.draws}",
                  label: "Draws",
                  color: AppColors.warning,
                ),
              ),
              AppSpacing.w12,
              Expanded(
                child: _SummaryStatCard(
                  value: "${teamData.losses}",
                  label: "Losses",
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          AppSpacing.h24,

          // Recent Matches Section
          Text(
            "Recent Matches",
            style: FontManager.heading3(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),

          AppSpacing.h16,

          // Recent Matches List
          _RecentMatchItem(
            homeTeam: "Manchester City",
            awayTeam: "Arsenal",
            homeScore: "2",
            awayScore: "2",
            date: "Yesterday",
          ),
          AppSpacing.h12,
          _RecentMatchItem(
            homeTeam: "Liverpool",
            awayTeam: teamData.teamName,
            homeScore: "1",
            awayScore: "3",
            date: "3 days ago",
          ),
          AppSpacing.h12,
          _RecentMatchItem(
            homeTeam: teamData.teamName,
            awayTeam: "Chelsea",
            homeScore: "2",
            awayScore: "0",
            date: "5 days ago",
          ),

          AppSpacing.h24,
        ],
      ),
    );
  }
}

/// Summary Stat Card Widget
class _SummaryStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _SummaryStatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: FontManager.heading2(
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
      ),
    );
  }
}

/// Recent Match Item Widget
class _RecentMatchItem extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String homeScore;
  final String awayScore;
  final String date;

  const _RecentMatchItem({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
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
            "$homeScore-$awayScore",
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

