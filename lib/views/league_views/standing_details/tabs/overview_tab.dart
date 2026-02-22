import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/league_views/standing_details/models/team_standings_data.dart';

class OverviewTab extends StatelessWidget {
  final TeamStandingsData teamData;
  final String homeTeam;
  final String awayTeam;
  final String score;

  const OverviewTab({
    super.key,
    required this.teamData,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppSpacing.h16,
        // 1. Orange Match Summary Card
        _buildMatchSummaryCard(),

        AppSpacing.h24,
      ]),
    );
  }

  /// 🟧 Section 1: The Orange Summary Card
  Widget _buildMatchSummaryCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EC), // Light Orange/Cream BG
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFFE0B2), width: 0.5),
      ),
      child: Column(
        children: [
          // Header: Icon + "Match Summary"
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7D54), // Dark Orange Icon BG
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.assignment, color: Colors.white, size: 16),
              ),
              AppSpacing.w12,
              Text(
                "Match Summary",
                style: FontManager.bodyMedium(
                  fontSize: 14,
                  color: const Color(0xFFFF7D54),
                ),
              ),
            ],
          ),

          AppSpacing.h16,
          const Divider(color: Color(0xFFFFE0B2), thickness: 0.5),
          AppSpacing.h16,

          // Stats Row: Goals | Possession | Goals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSingleStat(
                  score.isNotEmpty && score.contains("-")
                      ? score.split("-")[0].trim()
                      : "-",
                  homeTeam),
              _buildSingleStat("Match", "Status"),
              _buildSingleStat(
                  score.isNotEmpty && score.contains("-")
                      ? score.split("-")[1].trim()
                      : "-",
                  awayTeam),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: FontManager.heading2(
            fontSize: 22,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: FontManager.bodySmall(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// ⬜ Section 2: The Event Card (Grey Box)
  Widget _buildEventCard({
    required String time,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F8), // Light Grey BG
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Icon & Time
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              SizedBox(width: 8.w),
              Text(
                time,
                style: FontManager.bodyMedium(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          // Spacer to push text to the right
          const Spacer(),

          // Right Side: Player Info (Right Aligned)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: FontManager.heading4(
                  fontSize: 14,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: FontManager.bodySmall(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (description.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: FontManager.bodySmall(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
