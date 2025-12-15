import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_lineups.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_match_information.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/widget/navigation/transparent_tab_bar.dart';

class LiveMatchDetailsScreen extends StatefulWidget {
  const LiveMatchDetailsScreen({super.key});

  @override
  State<LiveMatchDetailsScreen> createState() => _LiveMatchDetailsScreenState();
}

class _LiveMatchDetailsScreenState extends State<LiveMatchDetailsScreen>
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
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            // Top Stack Section (Header + Match Overview + Tab Bar)
            Expanded(
              flex: 0,
              child: Stack(
                children: [
                  // Top Stack Background
                  _buildTopStack(),

                  // Transparent Tab Bar (overlaid at bottom)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TransparentTabBar(
                      tabController: _tabController,
                      tabs: const [
                        AppStrings.timeline,
                        AppStrings.lineups,
                        AppStrings.stats,
                        // AppStrings.commentary,
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
                  _buildTimelineTab(),
                  _buildLineupsTab(),
                  _buildStatsTab(),
                  _buildCommentaryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top Stack Section - Header + Match Overview
  Widget _buildTopStack() {
    return SizedBox(
      height: 270.h, // Increased to accommodate tab bar
      width: double.maxFinite,
      child: Stack(
        children: [
          // Stadium Background Image
          Positioned.fill(
            child: Image.asset(
              ImageAssets.home_bg, // Use stadium/match background image
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

          // Match Overview (Live Indicator, Teams, Score)
          _buildMatchOverview(),
        ],
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

              // League Name
              Text(
                "Premier League", // TODO: Get from match data
                style: FontManager.heading3(
                  fontSize: 18,
                  color: AppColors.white,
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

  /// Match Overview - Live Indicator, Teams, Score
  Widget _buildMatchOverview() {
    return Positioned(
      bottom: 0,
      top: 48,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.only(bottom: 60.h),
        child: Column(
          children: [
            // Live Indicator
            AppSpacing.h38,
            _buildLiveIndicator(),

            AppSpacing.h2,

            // Teams and Score
            _buildScoreboard(),
          ],
        ),
      ),
    );
  }

  /// Live Indicator Badge
  Widget _buildLiveIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.warning, // Yellow for LIVE
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing dot
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.w8,
          Text(
            "LIVE - 78'", // TODO: Get from match data
            style: FontManager.labelMedium(
              fontSize: 12,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Scoreboard with Team Logos and Scores
  Widget _buildScoreboard() {
    return Padding(
      padding: AppPadding.h24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home Team (Manchester City)
          Expanded(
            child: Column(
              children: [
                // Team Logo Placeholder
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sports_soccer,
                    color: AppColors.white,
                    size: 30.sp,
                  ),
                ),
                AppSpacing.h8,
                Text(
                  "Man City", // TODO: Get from match data
                  style: FontManager.bodyMedium(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Score
          Expanded(
            child: Column(
              children: [
                Text(
                  "2 - 2", // TODO: Get from match data
                  style: FontManager.matchScore(
                    fontSize: 34.sp,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          // Away Team (Arsenal)
          Expanded(
            child: Column(
              children: [
                // Team Logo Placeholder
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sports_soccer,
                    color: AppColors.white,
                    size: 30.sp,
                  ),
                ),
                AppSpacing.h8,
                Text(
                  "Arsenal", // TODO: Get from match data
                  style: FontManager.bodyMedium(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Timeline Tab Content
  Widget _buildTimelineTab() {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Column(
        children: [
          AppSpacing.h12,
          // Timeline events will go here
          _buildTimelineEvent("78'", "Bukayo Saka", "Goal"),
          AppSpacing.h16,
          _buildTimelineEvent("65'", "Yellow Card", "Player Name"),
          AppSpacing.h16,
          _buildTimelineEvent("45'", "Half Time", ""),
          AppSpacing.h16,
          WidgetMatchInformation(
              stadium: "Eihad Stadium",
              referee: "Farhan Shahriar",
              attendance: "512,800")
        ],
      ),
    );
  }

  /// Lineups Tab Content
  Widget _buildLineupsTab() {
    // Sample lineup data for Manchester City
    final manCityPlayers = [
      const Player(number: "31", name: "Ederson", position: "GK"),
      const Player(number: "2", name: "Kyle Walker", position: "RB"),
      const Player(number: "3", name: "Rúben Dias", position: "CB"),
      const Player(number: "6", name: "Nathan Aké", position: "CB"),
      const Player(number: "5", name: "John Stones", position: "LB"),
      const Player(number: "16", name: "Rodri", position: "CM"),
      const Player(number: "17", name: "Kevin De Bruyne", position: "CM"),
      const Player(number: "20", name: "Bernardo Silva", position: "CM"),
      const Player(number: "47", name: "Phil Foden", position: "RW"),
      const Player(number: "9", name: "Erling Haaland", position: "ST"),
      const Player(number: "10", name: "Jack Grealish", position: "LW"),
    ];

    // Sample lineup data for Arsenal
    final arsenalPlayers = [
      const Player(number: "1", name: "Aaron Ramsdale", position: "GK"),
      const Player(number: "4", name: "Ben White", position: "RB"),
      const Player(number: "6", name: "Gabriel Magalhães", position: "CB"),
      const Player(number: "2", name: "William Saliba", position: "CB"),
      const Player(number: "3", name: "Kieran Tierney", position: "LB"),
      const Player(number: "5", name: "Thomas Partey", position: "CM"),
      const Player(number: "8", name: "Martin Ødegaard", position: "CM"),
      const Player(number: "41", name: "Declan Rice", position: "CM"),
      const Player(number: "7", name: "Bukayo Saka", position: "RW"),
      const Player(number: "9", name: "Gabriel Jesus", position: "ST"),
      const Player(number: "11", name: "Gabriel Martinelli", position: "LW"),
    ];

    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Container(
        padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.h12,

            // Home Team Lineup (Manchester City)
            TeamLineupCard(
              teamName: "Manchester City",
              formation: "4-3-3",
              players: manCityPlayers,
            ),

            AppSpacing.h32,

            // Away Team Lineup (Arsenal)
            TeamLineupCard(
              teamName: "Arsenal",
              formation: "4-3-3",
              players: arsenalPlayers,
            ),

            AppSpacing.h24,

            // Match Information
            WidgetMatchInformation(
              stadium: "Etihad Stadium",
              referee: "Farhan Shahriar",
              attendance: "53,400",
            ),

            AppSpacing.h16,
          ],
        ),
      ),
    );
  }

  /// Stats Tab Content
  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Container(
        padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
        child: Column(
          children: [
            AppSpacing.h12,

            // Possession
            _buildStatRow("Possession", 54, 46),
            AppSpacing.h16,

            // Shots
            _buildStatRow("Shots", 14, 10),
            AppSpacing.h16,

            // Shots on Target
            _buildStatRow("Shots on Target", 7, 6),
            AppSpacing.h16,

            // Corners
            _buildStatRow("Corners", 6, 5),
            AppSpacing.h16,

            // Fouls
            _buildStatRow("Fouls", 8, 10),
            AppSpacing.h16,

            // Yellow Cards
            _buildStatRow("Yellow Cards", 0, 1),

            AppSpacing.h24,

            // Match Information
            WidgetMatchInformation(
              stadium: "Etihad Stadium",
              referee: "Farhan Shahriar",
              attendance: "53,400",
            ),

            AppSpacing.h16,
          ],
        ),
      ),
    );
  }

  /// Commentary Tab Content
  Widget _buildCommentaryTab() {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Column(
        children: [
          _buildCommentaryItem(
            "GOAL! Bukayo Saka with a right foot shot!",
            "78'",
          ),
          AppSpacing.h16,
          _buildCommentaryItem(
            "Corner kick for Arsenal",
            "75'",
          ),
          // More commentary items...
        ],
      ),
    );
  }

  /// Timeline Event Item
  Widget _buildTimelineEvent(
    String minute,
    String player,
    String event,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Minute
        Text(
          minute,
          style: FontManager.bodyMedium(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),

        AppSpacing.w12,

        /// Event Card
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Icon
                Icon(
                  Icons.sports_soccer_rounded,
                  size: 18.sp,
                  // color: AppColors.white,
                ),

                AppSpacing.w8,

                /// Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Player name
                      Text(
                        player,
                        style: FontManager.bodyMedium(
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      /// Event description
                      Text(
                        event,
                        style: FontManager.bodySmall(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Stat Row - Card-based design matching the image
  Widget _buildStatRow(String statName, int homeValue, int awayValue) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.bgTertiary, // Light grey background
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
          // Stat Name (centered)
          Text(
            statName,
            style: FontManager.labelMedium(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),

          // Values Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home Value (left)
              Text(
                homeValue.toString(),
                style: FontManager.heading3(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),

              // Away Value (right)
              Text(
                awayValue.toString(),
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
              // Home team progress (orange)
              Expanded(
                flex: homeValue == 0 && awayValue == 0
                    ? 1
                    : (homeValue == 0 ? 0 : homeValue),
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor, // Orange
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.r),
                      bottomLeft: Radius.circular(3.r),
                      topRight:
                          homeValue == 0 ? Radius.circular(3.r) : Radius.zero,
                      bottomRight:
                          homeValue == 0 ? Radius.circular(3.r) : Radius.zero,
                    ),
                  ),
                ),
              ),

              // Away team progress (yellow)
              Expanded(
                flex: homeValue == 0 && awayValue == 0
                    ? 1
                    : (awayValue == 0 ? 0 : awayValue),
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColors.warning, // Yellow
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3.r),
                      bottomRight: Radius.circular(3.r),
                      topLeft:
                          awayValue == 0 ? Radius.circular(3.r) : Radius.zero,
                      bottomLeft:
                          awayValue == 0 ? Radius.circular(3.r) : Radius.zero,
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

  /// Commentary Item
  Widget _buildCommentaryItem(String text, String minute) {
    return Container(
      padding: AppPadding.r16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppPadding.c12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: AppPadding.c4,
            ),
            child: Text(
              minute,
              style: FontManager.labelSmall(
                fontSize: 12,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          AppSpacing.w12,
          Expanded(
            child: Text(
              text,
              style: FontManager.bodyMedium(),
            ),
          ),
        ],
      ),
    );
  }
}
