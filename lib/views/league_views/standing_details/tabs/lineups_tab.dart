import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/services/league_service.dart';
import 'package:scorelivepro/models/live_ws_model.dart' as ws;

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

class LineupsTab extends StatefulWidget {
  final String teamName;
  final int? fixtureId;
  final int? homeTeamId;
  final int? awayTeamId;

  const LineupsTab({
    super.key,
    required this.teamName,
    this.fixtureId,
    this.homeTeamId,
    this.awayTeamId,
  });

  @override
  State<LineupsTab> createState() => _LineupsTabState();
}

class _LineupsTabState extends State<LineupsTab> {
  bool _isLoading = true;
  List<ws.Lineup>? _lineupData;

  @override
  void initState() {
    super.initState();
    _fetchLineups();
  }

  Future<void> _fetchLineups() async {
    if (widget.fixtureId == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    final data = await LeagueService.fetchMatchLineups(widget.fixtureId!);
    if (mounted) {
      setState(() {
        _lineupData = data;
        _isLoading = false;
      });
    }
  }

  // Map API players to UI Models
  List<DetailedPlayer> _mapPlayers(List<dynamic>? apiPlayers) {
    if (apiPlayers == null) return [];

    return apiPlayers.map((item) {
      final p = item.player;

      return DetailedPlayer(
        number: p?.number?.toString() ?? "-",
        name: p?.name ?? "Unknown",
        position: p?.pos ?? "N/A",
        // The API returns basics in lineup. rating/cards are usually in 'events'.
        // For now, keeping defaults to avoid massive complex mappings
        // until events data is explicitly passed/parsed for players.
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_lineupData == null || _lineupData!.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            "Lineup data not available yet.",
            style: FontManager.bodyMedium(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    // Identify Home/Away teams
    final homeLineup = _lineupData!.firstWhere(
      (l) => l.team?.id == widget.homeTeamId,
      orElse: () => _lineupData![0], // Fallback
    );

    final awayLineup = _lineupData!.firstWhere(
      (l) => l.team?.id == widget.awayTeamId,
      orElse: () => _lineupData!.length > 1 ? _lineupData![1] : _lineupData![0],
    );

    // Map the Starting XI and Substitutes
    final homeStartingXI = _mapPlayers(homeLineup.startXI);
    final homeSubs = _mapPlayers(homeLineup.substitutes);

    final awayStartingXI = _mapPlayers(awayLineup.startXI);
    final awaySubs = _mapPlayers(awayLineup.substitutes);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------- Home Team Column --------
          Expanded(
            child: _buildTeamColumn(
              teamName: homeLineup.team?.name ?? "Home",
              formation: homeLineup.formation ?? "-",
              startingXI: homeStartingXI,
              subs: homeSubs,
              color: AppColors.primaryColor, // Orange/Red
            ),
          ),

          SizedBox(width: 12.w), // Gap between columns

          // -------- Away Team Column --------
          Expanded(
            child: _buildTeamColumn(
              teamName: awayLineup.team?.name ?? "Away",
              formation: awayLineup.formation ?? "-",
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
