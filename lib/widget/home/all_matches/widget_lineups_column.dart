import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_lineups_detailed.dart';

/// Team Lineup Column Widget - Reusable component for one team's lineup
class TeamLineupColumn extends StatelessWidget {
  final String teamName;
  final String formation;
  final List<DetailedPlayer> startingXI;
  final List<DetailedPlayer> substitutes;
  final Color teamColor;

  const TeamLineupColumn({
    super.key,
    required this.teamName,
    required this.formation,
    required this.startingXI,
    required this.substitutes,
    required this.teamColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Team Name and Formation
        _buildTeamHeader(),

        SizedBox(height: 20.h),

        // Starting XI Section
        _buildSectionHeader("Starting XI"),

        SizedBox(height: 12.h),

        // Starting XI Players List - Using ListView.builder
        SizedBox(
          height: startingXI.length * 44.h, // Approximate height per player
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: startingXI.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: PlayerRowWidget(
                  player: startingXI[index],
                  numberColor: teamColor,
                  isStarting: true,
                ),
              );
            },
          ),
        ),

        SizedBox(height: 24.h),

        // Substitutes Section
        _buildSectionHeader("Substitutes"),

        SizedBox(height: 12.h),

        // Substitutes Players List - Using ListView.builder
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: substitutes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: PlayerRowWidget(
                player: substitutes[index],
                numberColor: AppColors.grey,
                isStarting: false,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTeamHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          teamName,
          style: FontManager.heading3(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          formation,
          style: FontManager.bodySmall(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: FontManager.heading4(
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Player Row Widget - Reusable component for displaying a player
class PlayerRowWidget extends StatelessWidget {
  final DetailedPlayer player;
  final Color numberColor;
  final bool isStarting;

  const PlayerRowWidget({
    super.key,
    required this.player,
    required this.numberColor,
    required this.isStarting,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Jersey Number Square
        _buildJerseyNumber(),

        SizedBox(width: 12.w),

        // Player Name
        Expanded(
          child: Text(
            player.name,
            style: FontManager.bodyMedium(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(width: 8.w),

        // Position Badge
        _buildPositionBadge(),

        // Rating and Events (only for starting XI)
        if (isStarting) ...[
          SizedBox(width: 8.w),
          if (player.rating != null) _buildRating(),
          _buildEventIcons(),
        ],
      ],
    );
  }

  Widget _buildJerseyNumber() {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: numberColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      alignment: Alignment.center,
      child: Text(
        player.number,
        style: FontManager.bodyMedium(
          fontSize: 14,
          color: AppColors.white,
        ).copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPositionBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.greyE8,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        player.position,
        style: FontManager.labelSmall(
          fontSize: 10,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: 14.sp,
          color: AppColors.warning,
        ),
        SizedBox(width: 2.w),
        Text(
          player.rating.toString(),
          style: FontManager.bodySmall(
            fontSize: 12,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 4.w),
      ],
    );
  }

  Widget _buildEventIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (player.hasYellowCard) _buildYellowCard(),
        if (player.hasRedCard) _buildRedCard(),
        if (player.goals != null && player.goals! > 0) _buildGoalIcon(),
        if (player.assists != null && player.assists! > 0) _buildAssistIcon(),
      ],
    );
  }

  Widget _buildYellowCard() {
    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Container(
        width: 16.w,
        height: 16.w,
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(3.r),
        ),
      ),
    );
  }

  Widget _buildRedCard() {
    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Container(
        width: 16.w,
        height: 16.w,
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(3.r),
        ),
      ),
    );
  }

  Widget _buildGoalIcon() {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 2.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            IconAssets.soccer_icon,
            width: 14.w,
            height: 14.w,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.sports_soccer, size: 14.sp);
            },
          ),
          SizedBox(width: 2.w),
          Text(
            "${player.goals}",
            style: FontManager.bodySmall(
              fontSize: 11,
              color: AppColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistIcon() {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 2.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(3.r),
            ),
            alignment: Alignment.center,
            child: Text(
              "A",
              style: FontManager.labelSmall(
                fontSize: 10,
                color: AppColors.white,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            "${player.assists}",
            style: FontManager.bodySmall(
              fontSize: 11,
              color: AppColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

