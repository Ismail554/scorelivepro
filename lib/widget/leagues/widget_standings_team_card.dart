import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';

class StandingsTeamCard extends StatelessWidget {
  final int rank;
  final String teamName;
  final int points;
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;

  const StandingsTeamCard({
    super.key,
    required this.rank,
    required this.teamName,
    required this.points,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
  });

  // Helper to get rank color
  Color _getRankColor() {
    if (rank <= 4) return AppColors.primaryColor; // Orange
    if (rank == 5) return AppColors.warning; // Yellow
    return AppColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final rankColor = _getRankColor();
    final gdText = goalDifference > 0 ? "+$goalDifference" : "$goalDifference";
    final gdColor = goalDifference > 0
        ? Colors.green
        : (goalDifference < 0 ? Colors.red : AppColors.textPrimary);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r), // Rounded corner like image
        border: Border.all(color: Colors.grey.shade200, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ----------------- TOP SECTION (Rank, Team, Points) -----------------
          Row(
            children: [
              // Rank Box (Rounded Square)
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: rankColor,
                  borderRadius: BorderRadius.circular(12.r), // Rounded square
                ),
                alignment: Alignment.center,
                child: Text(
                  rank.toString(),
                  style: FontManager.heading4(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
              ),

              AppSpacing.w12,

              // Team Logo (Circle Avatar Placeholder) & Name
              Expanded(
                child: Row(
                  children: [
                    // Team Logo Background
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6.w),
                      child: Image.asset(
                        IconAssets
                            .soccer_icon, // Replace with team logo url if available
                        fit: BoxFit.contain,
                      ),
                    ),
                    AppSpacing.w12,
                    // Team Name
                    Expanded(
                      child: Text(
                        teamName,
                        style: FontManager.bodyMedium(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Points Badge (Pill Shape)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "$points pts",
                  style: FontManager.labelMedium(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.h16,

          // ----------------- DIVIDER -----------------
          Divider(color: Colors.grey.shade200, thickness: 1.h),

          AppSpacing.h16,

          // ----------------- BOTTOM SECTION (Stats Grid) -----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn("Played", played.toString()),
              _buildStatColumn("W-D-L", "$wins-$draws-$losses"),
              _buildStatColumn("Goals", "$goalsFor-$goalsAgainst"),
              _buildStatColumn("GD", gdText, valueColor: gdColor),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget for Stats to keep code clean
  Widget _buildStatColumn(String label, String value, {Color? valueColor}) {
    return Column(
      children: [
        Text(
          label,
          style: FontManager.bodySmall(
            fontSize: 12,
            color: AppColors.textSecondary, // Grey color for label
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: FontManager.bodyMedium(
            fontSize: 14,

            color: valueColor ?? AppColors.textPrimary, // Custom color for GD
          ),
        ),
      ],
    );
  }
}
