import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Player model for lineup
class Player {
  final String number; // Jersey number as string
  final String name;
  final String position; // Position code like "GK", "RB", "CB", etc.

  const Player({
    required this.number,
    required this.name,
    required this.position,
  });
}

class TeamLineupCard extends StatelessWidget {
  final String teamName;
  final String formation; // Jemon: "4-3-3"
  final List<Player> players; // Player der list

  const TeamLineupCard({
    super.key,
    required this.teamName,
    required this.formation,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Team Name & Logo
        Row(
          children: [
            // Team Logo (circular)
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.greyE8,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_soccer,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              teamName,
              style: FontManager.heading3(
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // White Card Container
        Container(
          width: double.maxFinite,
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
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Formation Text
              Text(
                "Formation: $formation",
                style: FontManager.bodySmall(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),

              SizedBox(height: 20.h),

              // Player List
              ...List.generate(players.length, (index) {
                final player = players[index];
                final isLastItem = index == players.length - 1;

                return Column(
                  children: [
                    _buildPlayerRow(player),
                    if (!isLastItem)
                      Divider(
                        color: AppColors.greyE8,
                        height: 20.h,
                        thickness: 1,
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper: Single Player Row Design
  Widget _buildPlayerRow(Player player) {
    return Row(
      children: [
        // Orange Jersey Number Circle
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            player.number,
            style: FontManager.bodyMedium(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
        ),

        SizedBox(width: 16.w),

        // Player Name
        Expanded(
          child: Text(
            player.name,
            style: FontManager.bodyMedium(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ),

        // Position Code (GK, RB, CB...)
        Text(
          player.position,
          style: FontManager.bodySmall(
            color: AppColors.textTertiary,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
