import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
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
      backgroundColor: AppColors.bgColor,
      body: Container(
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
          // Timeline events will go here
          _buildTimelineEvent("78'", "Bukayo Saka", "Goal"),
          AppSpacing.h16,
          _buildTimelineEvent("65'", "Yellow Card", "Player Name"),
          AppSpacing.h16,
          _buildTimelineEvent("45'", "Half Time", ""),
        ],
      ),
    );
  }

  /// Lineups Tab Content
  Widget _buildLineupsTab() {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Home Team Lineup
          Text(
            "Manchester City",
            style: FontManager.heading3(),
          ),
          AppSpacing.h16,
          // Lineup items will go here
          _buildLineupItem("GK", "Player Name"),
          _buildLineupItem("DEF", "Player Name"),
          // ... more lineup items

          AppSpacing.h32,

          // Away Team Lineup
          Text(
            "Arsenal",
            style: FontManager.heading3(),
          ),
          AppSpacing.h16,
          // Lineup items will go here
        ],
      ),
    );
  }

  /// Stats Tab Content
  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Column(
        children: [
          // Possession
          _buildStatRow("Possession", 54, 46),
          AppSpacing.h24,
          // Shots
          _buildStatRow("Shots", 12, 8),
          AppSpacing.h24,
          // More stats...
        ],
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
  Widget _buildTimelineEvent(String minute, String player, String event) {
    return Row(
      children: [
        Text(
          minute,
          style: FontManager.bodyMedium(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.w16,
        Expanded(
          child: Text(
            "$player - $event",
            style: FontManager.bodyMedium(),
          ),
        ),
      ],
    );
  }

  /// Lineup Item
  Widget _buildLineupItem(String position, String playerName) {
    return Padding(
      padding: AppPadding.v8,
      child: Row(
        children: [
          Container(
            width: 40.w,
            padding: AppPadding.r8,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: AppPadding.c4,
            ),
            child: Text(
              position,
              style: FontManager.labelSmall(
                fontSize: 12,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacing.w12,
          Expanded(
            child: Text(
              playerName,
              style: FontManager.bodyMedium(),
            ),
          ),
        ],
      ),
    );
  }

  /// Stat Row
  Widget _buildStatRow(String statName, int homeValue, int awayValue) {
    return Column(
      children: [
        Text(
          statName,
          style: FontManager.labelMedium(
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.h8,
        Row(
          children: [
            Expanded(
              child: Text(
                "$homeValue%",
                style: FontManager.heading3(),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Text(
                "$awayValue%",
                style: FontManager.heading3(),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        AppSpacing.h8,
        // Progress bar
        Row(
          children: [
            Expanded(
              flex: homeValue,
              child: Container(
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: AppPadding.c4,
                ),
              ),
            ),
            Expanded(
              flex: awayValue,
              child: Container(
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: AppPadding.c4,
                ),
              ),
            ),
          ],
        ),
      ],
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
