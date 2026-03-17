import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/utils/navigation_helper.dart';
import 'package:scorelivepro/views/league_views/standing_details/models/team_standings_data.dart';
import 'package:scorelivepro/views/league_views/standing_details/tabs/h2h_tab.dart';
import 'package:scorelivepro/views/league_views/standing_details/tabs/lineups_tab.dart';
import 'package:scorelivepro/views/league_views/standing_details/tabs/overview_tab.dart';
import 'package:scorelivepro/views/league_views/standing_details/tabs/statistics_tab.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_match_header_info.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/widget/navigation/custom_bottom_nav_bar.dart';
import 'package:scorelivepro/widget/navigation/transparent_tab_bar.dart';

class DetailedStandingsScreen extends StatefulWidget {
  final String teamName;
  final int rank;
  final int points;
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;

  // Added Match specific parameters for Fixtures/Results integration
  final String? awayTeam;
  final String? score;
  final String? matchTime;
  final String? venue;
  final int? fixtureId;
  final int? homeTeamId;
  final int? awayTeamId;
  final String? leagueName;

  const DetailedStandingsScreen({
    super.key,
    required this.teamName,
    this.rank = 0,
    this.points = 0,
    this.played = 0,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.goalDifference = 0,
    this.awayTeam,
    this.score,
    this.matchTime,
    this.venue,
    this.fixtureId,
    this.homeTeamId,
    this.awayTeamId,
    this.leagueName,
  });

  @override
  State<DetailedStandingsScreen> createState() =>
      _DetailedStandingsScreenState();
}

class _DetailedStandingsScreenState extends State<DetailedStandingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3, // Leagues tab
        onTap: (index) {
          NavigationHelper.navigateToMainScreen(context, index);
        },
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            // Top Stack Section (Header + Tab Bar)
            Expanded(
              flex: 0,
              child: Stack(
                alignment: Alignment.bottomCenter, // Aligns tabs to bottom
                children: [
                  // Team Header Card (Background + Content)
                  _buildTeamHeader(),

                  // Transparent Tab Bar (overlaid at bottom)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TransparentTabBar(
                      tabController: _tabController,
                      tabs: const [
                        "Overview",
                        "Statistics",
                        "Lineups",
                        "H2H",
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body Part (Tab Content)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  OverviewTab(
                    teamData: _getTeamData(),
                    homeTeam: widget.teamName,
                    awayTeam: widget.awayTeam ?? "Opponent",
                    score: widget.score ?? "0 - 0",
                  ),
                  StatisticsTab(
                    fixtureId: widget.fixtureId,
                    homeTeamId: widget.homeTeamId,
                    awayTeamId: widget.awayTeamId,
                  ),
                  LineupsTab(
                    teamName: widget.teamName,
                    fixtureId: widget.fixtureId,
                    homeTeamId: widget.homeTeamId,
                    awayTeamId: widget.awayTeamId,
                  ),
                  H2HTab(fixtureId: widget.fixtureId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🛠️ Fixed: Replaced Positioned with a Column layout
  Widget _buildTeamHeader() {
    return SizedBox(
      height: 280.h, // Slightly increased height for better spacing
      width: double.maxFinite,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Stadium Background Image
          Image.asset(
            ImageAssets.home_bg,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: AppColors.darkGrey);
            },
          ),

          // 2. Dark Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.7), // Darker at bottom for TabBar readability
                ],
              ),
            ),
          ),

          // 3. Content Column (Header + Match Info)
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(), // Top Bar
                SizedBox(height: 12.h),
                // const Spacer(), // Pushes content apart dynamically
                _buildMatchOverview(), // Match Score Info
                SizedBox(height: 30.h), // Space reserved for the TabBar
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🛠️ Fixed: Removed Positioned widget
  Widget _buildHeader() {
    return Padding(
      padding: AppPadding.h16.copyWith(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),

          // League Name Badge
          if (widget.leagueName != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                widget.leagueName!,
                style: FontManager.labelMedium(
                  fontSize: 12,
                  color: AppColors.white,
                ),
              ),
            )
          else
            const SizedBox.shrink(),

          // Notification Bell
          NotificationBell(hasNotification: true),
        ],
      ),
    );
  }

  Widget _buildMatchOverview() {
    return MatchHeaderInfo(
      homeTeam: widget.teamName,
      awayTeam: widget.awayTeam ?? "TBD",
      score: widget.score ?? "- : -",
      dateTime: widget.matchTime ?? "TBD",
      venue: widget.venue ?? "TBD",
      statusColor: AppColors.finishedMatch,
    );
  }

  /// Get Team Data Model
  TeamStandingsData _getTeamData() {
    return TeamStandingsData(
      teamName: widget.teamName,
      rank: widget.rank,
      points: widget.points,
      played: widget.played,
      wins: widget.wins,
      draws: widget.draws,
      losses: widget.losses,
      goalsFor: widget.goalsFor,
      goalsAgainst: widget.goalsAgainst,
      goalDifference: widget.goalDifference,
    );
  }
}
