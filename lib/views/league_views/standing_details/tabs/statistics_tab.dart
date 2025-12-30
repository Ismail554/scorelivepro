import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Statistics Tab Widget
/// Displays team statistics with ListView.builder
class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Statistics data
    final statistics = [
      {'name': 'Possession', 'value': 58, 'opponentValue': 42},
      {'name': 'Shots', 'value': 18, 'opponentValue': 12},
      {'name': 'Shots on Target', 'value': 7, 'opponentValue': 5},
      {'name': 'Corners', 'value': 8, 'opponentValue': 4},
      {'name': 'Fouls', 'value': 11, 'opponentValue': 14},
      {'name': 'Yellow Cards', 'value': 2, 'opponentValue': 1},
      {'name': 'Red Cards', 'value': 0, 'opponentValue': 0},
      {'name': 'Offsides', 'value': 3, 'opponentValue': 2},
      {'name': 'Passes', 'value': 592, 'opponentValue': 438},
      {'name': 'Pass Accuracy', 'value': 88, 'opponentValue': 84},
      {'name': 'Tackles', 'value': 10, 'opponentValue': 22},
      {'name': 'Saves', 'value': 3, 'opponentValue': 5},
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: statistics.length,
      itemBuilder: (context, index) {
        final stat = statistics[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _StatRow(
            statName: stat['name'] as String,
            teamValue: stat['value'] as int,
            opponentValue: stat['opponentValue'] as int,
          ),
        );
      },
    );
  }
}

/// Stat Row Widget
class _StatRow extends StatelessWidget {
  final String statName;
  final int teamValue;
  final int opponentValue;

  const _StatRow({
    required this.statName,
    required this.teamValue,
    required this.opponentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1.w, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Values Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Team Value (left)
              Text(
                teamValue.toString(),
                style: FontManager.heading3(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
              // Stat Name (centered)
              Text(
                statName,
                style: FontManager.labelMedium(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              // Opponent Value (right)
              Text(
                opponentValue.toString(),
                style: FontManager.heading3(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Progress Bar
          Row(
            children: [
              // Team progress (orange)
              Expanded(
                flex: teamValue == 0 && opponentValue == 0
                    ? 1
                    : (teamValue == 0 ? 0 : teamValue),
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor, // Orange
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.r),
                      bottomLeft: Radius.circular(3.r),
                      topRight:
                          teamValue == 0 ? Radius.circular(3.r) : Radius.zero,
                      bottomRight:
                          teamValue == 0 ? Radius.circular(3.r) : Radius.zero,
                    ),
                  ),
                ),
              ),

              // Opponent progress (yellow)
              Expanded(
                flex: teamValue == 0 && opponentValue == 0
                    ? 1
                    : (opponentValue == 0 ? 0 : opponentValue),
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.warning, // Yellow
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3.r),
                      bottomRight: Radius.circular(3.r),
                      topLeft: opponentValue == 0
                          ? Radius.circular(3.r)
                          : Radius.zero,
                      bottomLeft: opponentValue == 0
                          ? Radius.circular(3.r)
                          : Radius.zero,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

