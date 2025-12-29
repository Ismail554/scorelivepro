import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/utils/navigation_helper.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_lineups_detailed.dart';
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
                  _buildOverviewTab(),
                  _buildStatisticsTab(),
                  _buildLineupsTab(),
                  _buildH2HTab(),
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
      top: 48,
      left: 0,
      right: 0,
      child: MatchHeaderInfo(
        homeTeam: widget.teamName,
        awayTeam: "Liverpool",
        score: "2 - 1",
        status: "FT",
        dateTime: "Sunday, December 7, 2025 - 16:30",
        venue: "Etihad Stadium, Manchester",
        statusColor: AppColors.finishedMatch,
      ),
    );
  }

  /// Team Header Section - Match Style Header
  Widget _buildTeamHeader() {
    return SizedBox(
      height: 270.h,
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

          // Match Overview (Teams, Score, Date, Venue)
          _buildMatchOverview(),
        ],
      ),
    );
  }

  /// Overview Tab Content
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h12,

          // Match Summary
          Text(
            "Team Overview",
            style: FontManager.heading3(
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),

          AppSpacing.h16,

          // Summary Text
          Text(
            "${widget.teamName} is currently ranked #${widget.rank} in the Premier League with ${widget.points} points. The team has played ${widget.played} matches, winning ${widget.wins}, drawing ${widget.draws}, and losing ${widget.losses}. They have scored ${widget.goalsFor} goals and conceded ${widget.goalsAgainst}, with a goal difference of ${widget.goalDifference > 0 ? '+' : ''}${widget.goalDifference}.",
            style: FontManager.bodyMedium(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

          AppSpacing.h24,

          // Summary Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryStatCard(
                  "${widget.wins}",
                  "Wins",
                  AppColors.success,
                ),
              ),
              AppSpacing.w12,
              Expanded(
                child: _buildSummaryStatCard(
                  "${widget.draws}",
                  "Draws",
                  AppColors.warning,
                ),
              ),
              AppSpacing.w12,
              Expanded(
                child: _buildSummaryStatCard(
                  "${widget.losses}",
                  "Losses",
                  AppColors.error,
                ),
              ),
            ],
          ),

          AppSpacing.h24,

          // Recent Matches Section
          Text(
            "Recent Matches",
            style: FontManager.heading3(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),

          AppSpacing.h16,

          // Recent Matches List
          _buildRecentMatchItem(
            "Manchester City",
            "Arsenal",
            "2",
            "2",
            "Yesterday",
          ),
          AppSpacing.h12,
          _buildRecentMatchItem(
            "Liverpool",
            widget.teamName,
            "1",
            "3",
            "3 days ago",
          ),
          AppSpacing.h12,
          _buildRecentMatchItem(
            widget.teamName,
            "Chelsea",
            "2",
            "0",
            "5 days ago",
          ),

          AppSpacing.h24,
        ],
      ),
    );
  }

  /// Statistics Tab Content with ListView.builder
  Widget _buildStatisticsTab() {
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
          child: _buildStatRow(
            stat['name'] as String,
            stat['value'] as int,
            stat['opponentValue'] as int,
          ),
        );
      },
    );
  }

  /// Stat Row Widget
  Widget _buildStatRow(String statName, int teamValue, int opponentValue) {
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

  /// Lineups Tab Content - Two Column Design
  Widget _buildLineupsTab() {
    // Home Team Starting XI
    final homeStartingXI = [
      const DetailedPlayer(
          number: "31", name: "Ederson", position: "GK", rating: 7.2),
      const DetailedPlayer(
          number: "2",
          name: "Kyle Walker",
          position: "DEF",
          rating: 7.5,
          hasYellowCard: true),
      const DetailedPlayer(
          number: "3", name: "Rúben Dias", position: "DEF", rating: 7.8),
      const DetailedPlayer(
          number: "6", name: "Nathan Aké", position: "DEF", rating: 7.3),
      const DetailedPlayer(
          number: "5", name: "John Stones", position: "DEF", rating: 7.4),
      const DetailedPlayer(
          number: "16",
          name: "Rodri",
          position: "MID",
          rating: 7.6,
          hasYellowCard: true),
      const DetailedPlayer(
          number: "17",
          name: "Kevin De Bruyne",
          position: "MID",
          rating: 8.2,
          assists: 1),
      const DetailedPlayer(
          number: "20", name: "Bernardo Silva", position: "MID", rating: 7.4),
      const DetailedPlayer(
          number: "47",
          name: "Phil Foden",
          position: "FWD",
          rating: 8.0,
          goals: 1),
      const DetailedPlayer(
          number: "9",
          name: "Erling Haaland",
          position: "FWD",
          rating: 8.5,
          goals: 1),
      const DetailedPlayer(
          number: "10", name: "Jack Grealish", position: "FWD", rating: 7.3),
    ];

    // Away Team Starting XI
    final awayStartingXI = [
      const DetailedPlayer(
          number: "1", name: "David Raya", position: "GK", rating: 7.0),
      const DetailedPlayer(
          number: "4", name: "Ben White", position: "DEF", rating: 7.2),
      const DetailedPlayer(
          number: "2", name: "William Saliba", position: "DEF", rating: 7.6),
      const DetailedPlayer(
          number: "6", name: "Gabriel", position: "DEF", rating: 7.4),
      const DetailedPlayer(
          number: "3",
          name: "Oleksandr Zinchenko",
          position: "DEF",
          rating: 7.1),
      const DetailedPlayer(
          number: "5",
          name: "Thomas Partey",
          position: "MID",
          rating: 7.3,
          hasYellowCard: true),
      const DetailedPlayer(
          number: "41", name: "Declan Rice", position: "MID", rating: 7.5),
      const DetailedPlayer(
          number: "8",
          name: "Martin Ødegaard",
          position: "MID",
          rating: 8.0,
          assists: 1),
      const DetailedPlayer(
          number: "7",
          name: "Bukayo Saka",
          position: "FWD",
          rating: 8.5,
          goals: 2),
      const DetailedPlayer(
          number: "9", name: "Eddie Nketiah", position: "FWD", rating: 7.2),
      const DetailedPlayer(
          number: "11",
          name: "Gabriel Martinelli",
          position: "FWD",
          rating: 7.4),
    ];

    // Home Team Substitutes
    final homeSubstitutes = [
      const DetailedPlayer(number: "18", name: "Stefan Ortega", position: "GK"),
      const DetailedPlayer(number: "82", name: "Rico Lewis", position: "DEF"),
      const DetailedPlayer(number: "21", name: "Sergio Gómez", position: "DEF"),
      const DetailedPlayer(
          number: "27", name: "Matheus Nunes", position: "MID"),
      const DetailedPlayer(
          number: "19", name: "Julián Álvarez", position: "FWD"),
      const DetailedPlayer(number: "11", name: "Jeremy Doku", position: "FWD"),
    ];

    // Away Team Substitutes
    final awaySubstitutes = [
      const DetailedPlayer(
          number: "22", name: "Aaron Ramsdale", position: "GK"),
      const DetailedPlayer(
          number: "12", name: "Jurriën Timber", position: "DEF"),
      const DetailedPlayer(number: "15", name: "Jakub Kiwior", position: "DEF"),
      const DetailedPlayer(number: "20", name: "Jorginho", position: "MID"),
      const DetailedPlayer(number: "29", name: "Kai Havertz", position: "MID"),
      const DetailedPlayer(number: "9", name: "Gabriel Jesus", position: "FWD"),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      child: DetailedLineupsWidget(
        homeTeam: widget.teamName,
        awayTeam: "Liverpool",
        homeFormation: "4-3-3",
        awayFormation: "4-3-3",
        homeStartingXI: homeStartingXI,
        awayStartingXI: awayStartingXI,
        homeSubstitutes: homeSubstitutes,
        awaySubstitutes: awaySubstitutes,
        homeColor: AppColors.primaryColor,
        awayColor: AppColors.warning,
      ),
    );
  }

  /// H2H (Head to Head) Tab Content
  Widget _buildH2HTab() {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h12,

          // Head to Head Record
          Text(
            "Head to Head",
            style: FontManager.heading3(
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),

          AppSpacing.h16,

          // H2H Stats
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.w,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "8",
                      style: FontManager.heading1(
                        fontSize: 24,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    AppSpacing.h4,
                    Text(
                      "Home Wins",
                      style: FontManager.bodySmall(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "3",
                      style: FontManager.heading1(
                        fontSize: 24,
                        color: AppColors.grey,
                      ),
                    ),
                    AppSpacing.h4,
                    Text(
                      "Draws",
                      style: FontManager.bodySmall(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "5",
                      style: FontManager.heading1(
                        fontSize: 24,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    AppSpacing.h4,
                    Text(
                      "Away Wins",
                      style: FontManager.bodySmall(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          AppSpacing.h24,

          // Last 5 Meetings
          Text(
            "Last 5 Meetings",
            style: FontManager.heading3(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),

          AppSpacing.h16,

          // Last 5 Meetings List
          _buildH2HMatchItem("Arsenal", "Man City", "1-0", "Oct 2025"),
          AppSpacing.h12,
          _buildH2HMatchItem("Man City", "Arsenal", "4-1", "Apr 2025"),
          AppSpacing.h12,
          _buildH2HMatchItem("Arsenal", "Man City", "1-3", "Feb 2025"),
          AppSpacing.h12,
          _buildH2HMatchItem("Man City", "Arsenal", "2-2", "Oct 2024"),
          AppSpacing.h12,
          _buildH2HMatchItem("Arsenal", "Man City", "0-0", "Apr 2024"),

          AppSpacing.h24,
        ],
      ),
    );
  }

  /// Helper Widgets
  Widget _buildSummaryStatCard(String value, String label, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: FontManager.heading2(
              fontSize: 24,
              color: color,
            ),
          ),
          AppSpacing.h4,
          Text(
            label,
            style: FontManager.bodySmall(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMatchItem(
    String homeTeam,
    String awayTeam,
    String homeScore,
    String awayScore,
    String date,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$homeTeam vs $awayTeam",
              style: FontManager.bodyMedium(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            "$homeScore-$awayScore",
            style: FontManager.heading4(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.w12,
          Text(
            date,
            style: FontManager.bodySmall(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildH2HMatchItem(
    String homeTeam,
    String awayTeam,
    String score,
    String date,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$homeTeam vs $awayTeam",
              style: FontManager.bodyMedium(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            score,
            style: FontManager.heading4(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.w12,
          Text(
            date,
            style: FontManager.bodySmall(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
