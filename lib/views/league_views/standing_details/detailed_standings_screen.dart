import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
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

  const DetailedStandingsScreen({
    super.key,
    required this.teamName,
    required this.rank,
    required this.points,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
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
                children: [
                  // Team Header Card
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
                  OverviewTab(teamData: _getTeamData()),
                  const StatisticsTab(),
                  LineupsTab(teamName: widget.teamName),
                  const H2HTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header with Back Button, League Name, and Notification Bell
  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: AppPadding.h16,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Premier League",
                  style: FontManager.labelMedium(
                    fontSize: 12,
                    color: AppColors.white,
                  ),
                ),
              ),

              // Notification Bell
              NotificationBell(
                hasNotification: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Match Overview - Teams, Score, Date, Venue
  Widget _buildMatchOverview() {
    return Positioned(
      bottom: 0,
      top: 88,
      left: 0,
      right: 0,
      child: MatchHeaderInfo(
        homeTeam: widget.teamName,
        awayTeam: "Liverpool",
        score: "2 - 1",
        dateTime: "Sunday, December 7, 2025 - 16:30",
        venue: "Etihad Stadium, Manchester",
        statusColor: AppColors.finishedMatch,
      ),
    );
  }

  /// Team Header Section - Match Style Header
  Widget _buildTeamHeader() {
    return SizedBox(
      height: 260.h,
      width: double.maxFinite,
      child: Stack(
        children: [
          // Stadium Background Image
          Positioned.fill(
            child: Image.asset(
              ImageAssets.home_bg,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.darkGrey);
              },
            ),
          ),

          // Dark Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),

          // Header (Back Button, League Name, Notification Bell)
          _buildHeader(),
          AppSpacing.h40,

          // Match Overview (Teams, Score, Date, Venue)
          _buildMatchOverview(),
        ],
      ),
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
