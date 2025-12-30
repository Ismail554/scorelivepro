import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/font_manager.dart';

// Player Model (Data Class)
class DetailedPlayer {
  final String number;
  final String name;
  final String position;
  final double? rating; // Rating optional (Subs may not have it)
  final bool hasYellowCard;
  final bool hasRedCard;
  final int goals;
  final int assists;

  const DetailedPlayer({
    required this.number,
    required this.name,
    required this.position,
    this.rating,
    this.hasYellowCard = false,
    this.hasRedCard = false,
    this.goals = 0,
    this.assists = 0,
  });
}

class LineupsTab extends StatelessWidget {
  final String teamName;

  const LineupsTab({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    // --- Mock Data (তোমার আগের ডাটাই ব্যবহার করছি) ---
    final homeStartingXI = [
      const DetailedPlayer(
          number: "31", name: "Ederson", position: "GK", rating: 7.2),
      const DetailedPlayer(
          number: "2",
          name: "Kyle Walker",
          position: "DEF",
          rating: 7.0,
          hasYellowCard: true),
      const DetailedPlayer(
          number: "3", name: "Rúben Dias", position: "DEF", rating: 7.5),
      const DetailedPlayer(
          number: "25", name: "Manuel Akanji", position: "DEF", rating: 7.3),
      const DetailedPlayer(
          number: "24", name: "Joško Gvardiol", position: "DEF", rating: 7.1),
      const DetailedPlayer(
          number: "16",
          name: "Rodri",
          position: "MID",
          rating: 7.8,
          hasYellowCard: true),
      const DetailedPlayer(
          number: "17",
          name: "Kevin De Bruyne",
          position: "MID",
          rating: 8.2,
          assists: 1),
      const DetailedPlayer(
          number: "47",
          name: "Phil Foden",
          position: "FWD",
          rating: 8.5,
          goals: 1),
      const DetailedPlayer(
          number: "9",
          name: "Erling Haaland",
          position: "FWD",
          rating: 8.9,
          goals: 1),
      const DetailedPlayer(
          number: "10", name: "Jack Grealish", position: "FWD", rating: 7.4),
    ];

    final awayStartingXI = [
      const DetailedPlayer(
          number: "22", name: "David Raya", position: "GK", rating: 7.8),
      const DetailedPlayer(
          number: "4", name: "Ben White", position: "DEF", rating: 7.2),
      const DetailedPlayer(
          number: "2", name: "William Saliba", position: "DEF", rating: 7.4),
      const DetailedPlayer(
          number: "6", name: "Gabriel", position: "DEF", rating: 7.3),
      const DetailedPlayer(
          number: "35", name: "Zinchenko", position: "DEF", rating: 7.0),
      const DetailedPlayer(
          number: "41", name: "Declan Rice", position: "MID", rating: 7.5),
      const DetailedPlayer(
          number: "8",
          name: "Martin Ødegaard",
          position: "MID",
          rating: 8.0,
          hasRedCard: true), // Example Red
      const DetailedPlayer(
          number: "7",
          name: "Bukayo Saka",
          position: "FWD",
          rating: 9.2,
          goals: 2),
    ];

    final homeSubs = [
      const DetailedPlayer(number: "18", name: "Stefan Ortega", position: "GK"),
      const DetailedPlayer(number: "82", name: "Rico Lewis", position: "DEF"),
      const DetailedPlayer(
          number: "19", name: "Julián Álvarez", position: "FWD"),
    ];

    final awaySubs = [
      const DetailedPlayer(number: "1", name: "Ramsdale", position: "GK"),
      const DetailedPlayer(number: "20", name: "Jorginho", position: "MID"),
      const DetailedPlayer(number: "9", name: "Gabriel Jesus", position: "FWD"),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------- Home Team Column --------
          Expanded(
            child: _buildTeamColumn(
              teamName: "Man City",
              formation: "4-3-3",
              startingXI: homeStartingXI,
              subs: homeSubs,
              color: AppColors.primaryColor, // Orange/Red
            ),
          ),

          SizedBox(width: 12.w), // Gap between columns

          // -------- Away Team Column --------
          Expanded(
            child: _buildTeamColumn(
              teamName: "Liverpool",
              formation: "4-3-3",
              startingXI: awayStartingXI,
              subs: awaySubs,
              color: AppColors.warning, // Yellow/Gold
            ),
          ),
        ],
      ),
    );
  }

  // --- 🏗️ Main Column Builder ---
  Widget _buildTeamColumn({
    required String teamName,
    required String formation,
    required List<DetailedPlayer> startingXI,
    required List<DetailedPlayer> subs,
    required Color color,
  }) {
    return Column(
      children: [
        // Header (Team Name & Formation)
        Text(
          teamName,
          style: FontManager.bodyMedium(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          formation,
          style: FontManager.bodySmall(
              fontSize: 12, color: AppColors.textSecondary),
        ),
        SizedBox(height: 12.h),

        // Starting XI Card
        _buildSectionCard(
          title: "Starting XI",
          players: startingXI,
          themeColor: color,
        ),

        SizedBox(height: 16.h),

        // Substitutes Card
        _buildSectionCard(
          title: "Substitutes",
          players: subs,
          themeColor: color,
          isSubstitute: true,
        ),
      ],
    );
  }

  // --- 📦 Card Container Builder ---
  Widget _buildSectionCard({
    required String title,
    required List<DetailedPlayer> players,
    required Color themeColor,
    bool isSubstitute = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (Orange/Yellow Text)
          Padding(
            padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
            child: Text(
              title,
              style: FontManager.bodyMedium(
                fontSize: 12,
                color: themeColor,
              ),
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey.shade100),

          // Players List
          ...players.map(
              (player) => _buildPlayerRow(player, themeColor, isSubstitute)),
        ],
      ),
    );
  }

  // --- 🏃 Individual Player Row ---
  Widget _buildPlayerRow(
      DetailedPlayer player, Color color, bool isSubstitute) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align to top if multi-line
        children: [
          // Jersey Number Box
          Container(
            width: 24.w,
            height: 24.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              player.number,
              style: FontManager.bodySmall(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // Name & Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  player.name,
                  style: FontManager.bodyMedium(
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 2.h),

                // Position & Rating Row
                Row(
                  children: [
                    Text(
                      player.position,
                      style: FontManager.bodySmall(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (!isSubstitute && player.rating != null) ...[
                      SizedBox(width: 4.w),
                      Icon(Icons.star, size: 10.sp, color: Colors.grey),
                      SizedBox(width: 2.w),
                      Text(
                        player.rating.toString(),
                        style: FontManager.bodySmall(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                )
              ],
            ),
          ),

          // Events (Goals / Cards)
          Row(
            children: [
              if (player.goals > 0)
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Row(
                    children: [
                      Icon(Icons.sports_soccer,
                          size: 12.sp, color: AppColors.textPrimary),
                      if (player.goals > 1)
                        Text(" ${player.goals}",
                            style: FontManager.bodySmall(fontSize: 10)),
                    ],
                  ),
                ),
              if (player.hasYellowCard)
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Container(
                    width: 8.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                        color: Colors.yellow[700],
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              if (player.hasRedCard)
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Container(
                    width: 8.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
