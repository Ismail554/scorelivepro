import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/utils/navigation_helper.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_lineups.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_match_information.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/widget/navigation/custom_bottom_nav_bar.dart';
import 'package:scorelivepro/widget/navigation/transparent_tab_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/match_provider.dart';
import 'package:marquee/marquee.dart';

import 'package:scorelivepro/models/live_ws_model.dart' hide Player;

class LiveMatchDetailsScreen extends StatefulWidget {
  final Data matchData;
  const LiveMatchDetailsScreen({required this.matchData, super.key});

  @override
  State<LiveMatchDetailsScreen> createState() => _LiveMatchDetailsScreenState();
}

class _LiveMatchDetailsScreenState extends State<LiveMatchDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch details using provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.matchData.id != null) {
        Provider.of<MatchProvider>(context, listen: false)
            .fetchMatchDetails(widget.matchData.id!);
      }
    });
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
        currentIndex: 0, // Matches tab
        onTap: (index) {
          NavigationHelper.navigateToMainScreen(context, index);
        },
      ),
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Builder(
                    builder: (context) {
                      final leagueName =
                          widget.matchData.league?.name ?? "Unknown League";
                      final textStyle = FontManager.heading3(
                        fontSize: 18,
                        color: AppColors.white,
                      );

                      // Calculate text width
                      final textPainter = TextPainter(
                        text: TextSpan(text: leagueName, style: textStyle),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout(minWidth: 0, maxWidth: double.infinity);

                      // Use a simplified check or LayoutBuilder if precise width needed.
                      // Here we can use a LayoutBuilder for the container width.
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final isOverflowing =
                              textPainter.width > constraints.maxWidth;

                          if (isOverflowing) {
                            return SizedBox(
                              height: 30.h,
                              child: Marquee(
                                text: leagueName,
                                style: textStyle,
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                blankSpace: 20.0,
                                velocity: 30.0,
                                pauseAfterRound: const Duration(seconds: 1),
                                startPadding: 10.0,
                                accelerationDuration:
                                    const Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration:
                                    const Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            );
                          } else {
                            return Text(
                              leagueName,
                              style: textStyle,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        },
                      );
                    },
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

  /// Match Overview - Live Indicator, Teams, Score
  Widget _buildMatchOverview() {
    return Positioned(
      bottom: 0,
      top: 48,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Column(
          children: [
            // Live Indicator
            AppSpacing.h24,
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
            "${widget.matchData.statusShort ?? 'LIVE'} - ${widget.matchData.elapsed ?? 0}'",
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
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Home Team
          Expanded(
            child: _buildTeam(
              logo: widget.matchData.homeTeam?.logo ?? "",
              name: widget.matchData.homeTeam?.name ?? "Home",
            ),
          ),

          // Score (always center)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              "${widget.matchData.goals?.home ?? 0} - ${widget.matchData.goals?.away ?? 0}",
              style: FontManager.matchScore(
                fontSize: 34.sp,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Away Team
          Expanded(
            child: _buildTeam(
              logo: widget.matchData.awayTeam?.logo ?? "",
              name: widget.matchData.awayTeam?.name ?? "Away",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeam({
    required String logo,
    required String name,
  }) {
    // Calculate text width to decide if marquee is needed
    final textStyle = FontManager.bodyMedium(
      fontSize: 14,
      color: AppColors.white,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: name, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final isOverflowing = textPainter.width > 90.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: CachedNetworkImage(
              imageUrl: logo,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  Image.asset(IconAssets.soccer_icon),
              errorWidget: (context, url, error) =>
                  Image.asset(IconAssets.soccer_icon),
            ),
          ),
        ),
        AppSpacing.h8,
        SizedBox(
          width: 120.w,
          height: 20.h, // Fixed height for text area
          child: isOverflowing
              ? Marquee(
                  text: name,
                  style: textStyle,
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  blankSpace: 20.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 10.0,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                )
              : Center(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                ),
        ),
      ],
    );
  }

  /// Timeline Tab Content
  Widget _buildTimelineTab() {
    final events = widget.matchData.events ?? [];

    if (events.isEmpty) {
      return Center(
        child: Text(
          "Timeline will be available soon",
          style: FontManager.bodyMedium(color: AppColors.textSecondary),
        ),
      );
    }

    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Container(
        padding: EdgeInsets.only(bottom: 24.h, top: 8.h),
        child: Column(
          children: [
            AppSpacing.h12,

            // Map events to widgets
            ...events.map((event) {
              return Column(
                children: [
                  _buildTimelineEvent(
                    "${event.time?.elapsed ?? 0}",
                    event.player?.name ?? "Unknown Player",
                    event.type ?? "Event",
                    event.detail ?? "",
                  ),
                  AppSpacing.h16,
                ],
              );
            }).toList(),

            // Match Information
            WidgetMatchInformation(
              stadium: widget.matchData.venue?.name ?? "-----------",
              referee: widget.matchData.referee ?? "-----------",
            ),
          ],
        ),
      ),
    );
  }

  /// Lineups Tab Content
  Widget _buildLineupsTab() {
    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final matchId = widget.matchData.id;
        final lineups =
            (matchId != null ? provider.getLineups(matchId) : null) ??
                widget.matchData.lineups;
        final isLoading = matchId != null ? provider.isLoading(matchId) : false;

        debugPrint(
            "Building LineupsTab: matchId=$matchId, loading=$isLoading, data=${lineups?.length}");

        if (isLoading && (lineups == null || lineups.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (lineups == null || lineups.isEmpty) {
          // Also wrap empty state in RefreshIndicator so user can retry manually
          return RefreshIndicator(
            onRefresh: () async {
              if (matchId != null) {
                await provider.fetchMatchDetails(matchId, isRefresh: true);
              }
            },
            child: ListView(
              // Changed to ListView to ensure pulling works even on empty
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 100.h),
                Center(
                  child: Text(
                    "Lineups not available yet",
                    style:
                        FontManager.bodyMedium(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          );
        }

        // Identify Home and Away Lineups
        // We compare team ID with match home/away team ID
        final homeTeamId = widget.matchData.homeTeam?.id;
        final awayTeamId = widget.matchData.awayTeam?.id;

        // Use firstWhere or similar logic.
        // API usually returns 2 items.
        final homeLineup = lineups.firstWhere(
          (l) => l.team?.id == homeTeamId,
          orElse: () => lineups[0], // Fallback
        );

        final awayLineup = lineups.firstWhere(
          (l) => l.team?.id == awayTeamId,
          orElse: () => lineups.length > 1 ? lineups[1] : lineups[0],
        );

        // Helper to convert model players to UI players
        List<Player> getUiPlayers(List<dynamic>? startXI) {
          if (startXI == null) return [];
          return startXI.map((item) {
            // item is StartXI from model
            final p = item.player;
            return Player(
              number: p?.number ?? "0",
              name: p?.name ?? "Unknown",
              position: p?.pos ?? "",
            );
          }).toList();
        }

        final homePlayers = getUiPlayers(homeLineup.startXI);
        final awayPlayers = getUiPlayers(awayLineup.startXI);

        return RefreshIndicator(
          onRefresh: () async {
            if (matchId != null) {
              await provider.fetchMatchDetails(matchId, isRefresh: true);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppPadding.h16,
            child: Container(
              padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.h12,

                  // Home Team Lineup
                  TeamLineupCard(
                    teamName: homeLineup.team?.name ?? "Home Team",
                    formation: homeLineup.formation ?? "",
                    players: homePlayers,
                  ),

                  AppSpacing.h32,

                  // Away Team Lineup
                  TeamLineupCard(
                    teamName: awayLineup.team?.name ?? "Away Team",
                    formation: awayLineup.formation ?? "",
                    players: awayPlayers,
                  ),

                  AppSpacing.h24,

                  // Match Information
                  WidgetMatchInformation(
                    stadium: widget.matchData.venue?.name ?? "-----------",
                    referee: widget.matchData.referee ?? "-----------",
                  ),

                  AppSpacing.h16,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Stats Tab Content
  Widget _buildStatsTab() {
    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final matchId = widget.matchData.id;
        final statistics =
            (matchId != null ? provider.getStatistics(matchId) : null) ??
                widget.matchData.statistics;
        final isLoading = matchId != null ? provider.isLoading(matchId) : false;

        debugPrint(
            "Building StatsTab: matchId=$matchId, loading=$isLoading, data=${statistics?.length}");

        if (isLoading && (statistics == null || statistics.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (statistics == null || statistics.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              if (matchId != null) {
                await provider.fetchMatchDetails(matchId, isRefresh: true);
              }
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 100.h),
                Center(
                  child: Text(
                    "Statistics not available yet",
                    style:
                        FontManager.bodyMedium(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          );
        }

        final homeTeamId = widget.matchData.homeTeam?.id;
        final awayTeamId = widget.matchData.awayTeam?.id;

        final homeStats = statistics
                .firstWhere(
                  (s) => s.team?.id == homeTeamId,
                  orElse: () => statistics[0],
                )
                .statistics ??
            [];

        final awayStats = statistics
                .firstWhere(
                  (s) => s.team?.id == awayTeamId,
                  orElse: () =>
                      statistics.length > 1 ? statistics[1] : statistics[0],
                )
                .statistics ??
            [];

        // Combine all types to show
        final Set<String> types = {};
        for (var s in homeStats) if (s.type != null) types.add(s.type!);
        for (var s in awayStats) if (s.type != null) types.add(s.type!);

        // Helper to extract int value
        int parseValue(dynamic value) {
          if (value == null) return 0;
          if (value is int) return value;
          if (value is String) {
            // Remove % if present
            final clean = value.replaceAll('%', '').trim();
            return int.tryParse(clean) ?? 0;
          }
          return 0;
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (matchId != null) {
              await provider.fetchMatchDetails(matchId, isRefresh: true);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppPadding.h16,
            child: Container(
              padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
              child: Column(
                children: [
                  AppSpacing.h12,

                  if (types.isEmpty)
                    Text("No statistics data found",
                        style: FontManager.bodyMedium()),

                  ...types.map((type) {
                    final homeItem = homeStats.firstWhere((s) => s.type == type,
                        orElse: () => StatisticItem(type: type, value: 0));
                    final awayItem = awayStats.firstWhere((s) => s.type == type,
                        orElse: () => StatisticItem(type: type, value: 0));

                    return Column(
                      children: [
                        _buildStatRow(type, parseValue(homeItem.value),
                            parseValue(awayItem.value)),
                        AppSpacing.h16,
                      ],
                    );
                  }).toList(),

                  AppSpacing.h8,

                  // Match Information
                  WidgetMatchInformation(
                    stadium: widget.matchData.venue?.name ?? "-----------",
                    referee: widget.matchData.referee ?? "-----------",
                  ),

                  AppSpacing.h16,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Timeline Event Item
  Widget _buildTimelineEvent(
    String minute,
    String player,
    String type,
    String detail,
  ) {
    String iconPath = IconAssets.soccer_icon;

    // Check type/detail for icon
    if (detail.toLowerCase().contains("yellow") ||
        type.toLowerCase().contains("card")) {
      if (detail.toLowerCase().contains("yellow")) {
        iconPath = IconAssets.yellow_card;
      } else if (detail.toLowerCase().contains("red")) {
        iconPath = IconAssets.red_card;
      }
    } else if (type.toLowerCase() == "goal") {
      iconPath = IconAssets.soccer_icon;
    }

    // Fallback or specific mapping can be improved
    ;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Minute
        Text(
          "$minute''",
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
                Image.asset(
                  iconPath,
                  height: 14.h,
                  width: 14.h,
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
                        "$type - $detail",
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
        color: AppColors.white, // Light grey background
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
              // Home Value (left)
              Text(
                homeValue.toString(),
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
                  height: 8.h,
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
                  height: 8.h,
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
}
