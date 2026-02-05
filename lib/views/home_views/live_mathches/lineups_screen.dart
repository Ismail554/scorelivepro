import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:scorelivepro/provider/match_provider.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_lineups.dart' as ul;
import 'package:scorelivepro/widget/home/all_matches/widget_match_header_view.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_match_information.dart';

class HomeLineupsScreen extends StatefulWidget {
  final Data matchData;
  const HomeLineupsScreen({super.key, required this.matchData});

  @override
  State<HomeLineupsScreen> createState() => _LineupsScreenState();
}

class _LineupsScreenState extends State<HomeLineupsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fixtureId = widget.matchData.id;
      if (fixtureId != null) {
        // Fetch lineups if not already available
        Provider.of<MatchProvider>(context, listen: false)
            .fetchMatchDetails(fixtureId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Upcoming Match Lineups",
            style: FontManager.newsTitle(color: AppColors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.white),
        // We will overlay this on top of the header image, or handle differently.
        // The WidgetMatchHeaderView handles its own background so we might want Transparent AppBar or none.
      ),
      extendBodyBehindAppBar: true,
      body: Consumer<MatchProvider>(
        builder: (context, provider, child) {
          final matchId = widget.matchData.id;
          final lineups = matchId != null ? provider.getLineups(matchId) : null;
          final isLoading =
              matchId != null ? provider.isLoading(matchId) : false;

          // Process lineups into lists of Players
          List<ul.Player> homePlayers = [];
          List<ul.Player> awayPlayers = [];
          String homeFormation = "";
          String awayFormation = "";

          if (lineups != null && lineups.length >= 2) {
            // Basic parsing - assumes index 0 is home, 1 is away or check team ID?
            // Lineup model has 'team' field to verify.
            final homeId = widget.matchData.homeTeam?.id;

            final homeLineup = lineups.firstWhere((l) => l.team?.id == homeId,
                orElse: () => lineups[0]);
            final awayLineup = lineups.firstWhere((l) => l.team?.id != homeId,
                orElse: () => lineups.length > 1 ? lineups[1] : lineups[0]);

            homeFormation = homeLineup.formation ?? "";
            awayFormation = awayLineup.formation ?? "";

            if (homeLineup.startXI != null) {
              homePlayers = homeLineup.startXI!
                  .map((p) => ul.Player(
                        number: p.player?.number?.toString() ?? "-",
                        name: p.player?.name ?? "Unknown",
                        position: p.player?.pos ?? "",
                      ))
                  .toList();
            }

            if (awayLineup.startXI != null) {
              awayPlayers = awayLineup.startXI!
                  .map((p) => ul.Player(
                        number: p.player?.number?.toString() ?? "-",
                        name: p.player?.name ?? "Unknown",
                        position: p.player?.pos ?? "",
                      ))
                  .toList();
            }
          }

          return SafeArea(
            top: false,
            bottom: true,
            child: Column(
              children: [
                //Top Match Header Part
                WidgetMatchHeaderView(
                  backgroundImage: ImageAssets.home_bg,
                  leagueName: widget.matchData.league?.name ?? "Match Lineups",
                  matchStatus: widget.matchData.statusShort ?? 'LIVE',
                  homeTeamName: widget.matchData.homeTeam?.name ?? 'Home',
                  awayTeamName: widget.matchData.awayTeam?.name ?? 'Away',
                  score:
                      "${widget.matchData.goals?.home ?? 0} - ${widget.matchData.goals?.away ?? 0}",
                  onNotificationPressed: () {},
                  // Removed homeLogo and awayLogo as they are not properties of WidgetMatchHeaderView
                ),
                //Lineups Body Part
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: AppPadding.h16,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSpacing.h12,

                                if (lineups == null || lineups.isEmpty)
                                  Center(
                                      child: Text("No lineup data available",
                                          style: FontManager.bodyMedium())),

                                if (lineups != null && lineups.isNotEmpty) ...[
                                  // Home Team Lineup
                                  ul.TeamLineupCard(
                                    teamName: widget.matchData.homeTeam?.name ??
                                        "Home Team",
                                    formation: homeFormation,
                                    players: homePlayers,
                                  ),

                                  AppSpacing.h32,

                                  // Away Team Lineup
                                  ul.TeamLineupCard(
                                    teamName: widget.matchData.awayTeam?.name ??
                                        "Away Team",
                                    formation: awayFormation,
                                    players: awayPlayers,
                                  ),
                                ],

                                AppSpacing.h24,

                                // Match Information
                                WidgetMatchInformation(
                                  stadium: widget.matchData.venue?.name ??
                                      "Unknown Stadium",
                                  referee: widget.matchData.referee ??
                                      "Unknown Referee",
                                ),

                                AppSpacing.h16,
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
