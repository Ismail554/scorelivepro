import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_lineups_column.dart';

/// Enhanced Player model with rating and events
class DetailedPlayer {
  final String number;
  final String name;
  final String position; // GK, DEF, MID, FWD
  final double? rating; // e.g., 7.2
  final int? goals;
  final int? assists;
  final bool hasYellowCard;
  final bool hasRedCard;

  const DetailedPlayer({
    required this.number,
    required this.name,
    required this.position,
    this.rating,
    this.goals,
    this.assists,
    this.hasYellowCard = false,
    this.hasRedCard = false,
  });
}

/// Detailed Lineups Widget - Two Column Design
class DetailedLineupsWidget extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String homeFormation;
  final String awayFormation;
  final List<DetailedPlayer> homeStartingXI;
  final List<DetailedPlayer> awayStartingXI;
  final List<DetailedPlayer> homeSubstitutes;
  final List<DetailedPlayer> awaySubstitutes;
  final Color homeColor;
  final Color awayColor;

  const DetailedLineupsWidget({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeFormation,
    required this.awayFormation,
    required this.homeStartingXI,
    required this.awayStartingXI,
    required this.homeSubstitutes,
    required this.awaySubstitutes,
    this.homeColor = AppColors.primaryColor,
    this.awayColor = AppColors.warning,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Home Team Column
          Expanded(
            child: TeamLineupColumn(
              teamName: homeTeam,
              formation: homeFormation,
              startingXI: homeStartingXI,
              substitutes: homeSubstitutes,
              teamColor: homeColor,
            ),
          ),

          SizedBox(width: 16.w),

          // Away Team Column
          Expanded(
            child: TeamLineupColumn(
              teamName: awayTeam,
              formation: awayFormation,
              startingXI: awayStartingXI,
              substitutes: awaySubstitutes,
              teamColor: awayColor,
            ),
          ),
        ],
      ),
    );
  }
}

