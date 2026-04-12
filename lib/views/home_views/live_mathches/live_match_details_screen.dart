import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
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
import 'package:scorelivepro/widget/common/auto_marquee_text.dart';
import 'package:scorelivepro/widget/mini_widget/mw_blinking_dot.dart';

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
                      tabs: [
                        AppLocalizations.of(context).timeline,
                        AppLocalizations.of(context).lineups,
                        AppLocalizations.of(context).stats,
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
    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        // Use live data if available, otherwise fallback to widget data
        final currentMatch = (widget.matchData.id != null)
            ? (provider.getMatch(widget.matchData.id!) ?? widget.matchData)
            : widget.matchData;

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
                        Colors.black.withValues(alpha: 0.4),
                        Colors.black.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                ),
              ),

              // Header (Back Button, League Name, Notification Bell)
              Positioned(
                top: -16,
                left: 0,
                right: 0,
                child: _buildHeader(currentMatch),
              ),

              // Match Overview (Live Indicator, Teams, Score)
              _buildMatchOverview(currentMatch),
            ],
          ),
        );
      },
    );
  }

  /// Header with Back Button, League Name, and Notification Bell
  Widget _buildHeader(Data matchData) {
    return SafeArea(
      child: Padding(
        padding: AppPadding.h10,
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

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Center(
                  child: AutoMarqueeText(
                    text: matchData.league?.name ??
                        AppLocalizations.of(context).unknownLeague,
                    style: FontManager.heading3(
                      fontSize: 18,
                      color: AppColors.white,
                    ),
                    height: 30.h,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Notification Bell
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: NotificationBell(
                hasNotification: true,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Match Overview - Live Indicator, Teams, Score
  Widget _buildMatchOverview(Data matchData) {
    return Positioned(
      bottom: 12.h,
      top: 48,
      left: 0,
      right: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Live Indicator
          _buildLiveIndicator(matchData),
          SizedBox(height: 12.h),
          // Scoreboard
          _buildScoreboard(matchData),
        ],
      ),
    );
  }

  /// Live Indicator Badge
  Widget _buildLiveIndicator(Data matchData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlinkingDot(
            color: AppColors.white,
            size: 8,
          ),
          AppSpacing.w8,
          Text(
            "${matchData.statusShort ?? 'LIVE'} - ${matchData.elapsed ?? 0}'",
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
  Widget _buildScoreboard(Data matchData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Home Team
          Expanded(
            child: _buildTeam(
              logo: matchData.homeTeam?.logo ?? "",
              name: matchData.homeTeam?.name ?? "Home",
            ),
          ),

          // Score
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              "${matchData.goals?.home ?? 0} - ${matchData.goals?.away ?? 0}",
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
              logo: matchData.awayTeam?.logo ?? "",
              name: matchData.awayTeam?.name ?? "Away",
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
    final textStyle = FontManager.bodyMedium(
      fontSize: 14,
      color: AppColors.white,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
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
          width: double.infinity,
          child: AutoMarqueeText(
            text: name,
            style: textStyle,
            height: 20.h,
            textAlign: TextAlign.center,
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
          AppLocalizations.of(context).timelineAvailableSoon,
          style: FontManager.bodyMedium(color: AppColors.textSecondary),
        ),
      );
    }

    return SingleChildScrollView(
      padding: AppPadding.h16,
      child: Container(
        padding: EdgeInsets.only(bottom: 24.h, top: 16.h),
        child: Column(
          children: [
            ...events.map((event) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildTimelineEvent(
                  "${event.time?.elapsed ?? 0}",
                  event.player?.name ??
                      AppLocalizations.of(context).unknownPlayer,
                  event.type ?? AppLocalizations.of(context).event,
                  event.detail ?? "",
                ),
              );
            }),
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

        if (isLoading && (lineups == null || lineups.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (lineups == null || lineups.isEmpty) {
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
                    AppLocalizations.of(context).lineupsNotAvailableYet,
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

        final homeLineup = lineups.firstWhere(
          (l) => l.team?.id == homeTeamId,
          orElse: () => lineups[0],
        );

        final awayLineup = lineups.firstWhere(
          (l) => l.team?.id == awayTeamId,
          orElse: () => lineups.length > 1 ? lineups[1] : lineups[0],
        );

        List<Player> getUiPlayers(List<dynamic>? startXI) {
          if (startXI == null) return [];
          return startXI.map((item) {
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
            child: Column(
              children: [
                SizedBox(height: 16.h),
                TeamLineupCard(
                  teamName: homeLineup.team?.name ?? "Home Team",
                  formation: homeLineup.formation ?? "",
                  players: homePlayers,
                ),
                AppSpacing.h32,
                TeamLineupCard(
                  teamName: awayLineup.team?.name ?? "Away Team",
                  formation: awayLineup.formation ?? "",
                  players: awayPlayers,
                ),
                AppSpacing.h24,
                WidgetMatchInformation(
                  stadium: widget.matchData.venue?.name ?? "-----------",
                  referee: widget.matchData.referee ?? "-----------",
                ),
                SizedBox(height: 16.h),
              ],
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
                    AppLocalizations.of(context).statisticsNotAvailableYet,
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

        final Set<String> types = {};
        for (var s in homeStats) if (s.type != null) types.add(s.type!);
        for (var s in awayStats) if (s.type != null) types.add(s.type!);

        int parseValue(dynamic value) {
          if (value == null) return 0;
          if (value is int) return value;
          if (value is String) {
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
            child: Column(
              children: [
                SizedBox(height: 16.h),
                if (types.isEmpty)
                  Text(AppLocalizations.of(context).noStatisticsData,
                      style: FontManager.bodyMedium()),
                ...types.map((type) {
                  final homeItem = homeStats.firstWhere((s) => s.type == type,
                      orElse: () => StatisticItem(type: type, value: 0));
                  final awayItem = awayStats.firstWhere((s) => s.type == type,
                      orElse: () => StatisticItem(type: type, value: 0));

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _buildStatRow(type, parseValue(homeItem.value),
                        parseValue(awayItem.value)),
                  );
                }),
                WidgetMatchInformation(
                  stadium: widget.matchData.venue?.name ?? "-----------",
                  referee: widget.matchData.referee ?? "-----------",
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Timeline Event Item
  Widget _buildTimelineEvent(
      String minute, String player, String type, String detail) {
    String iconPath = IconAssets.soccer_icon;
    if (detail.toLowerCase().contains("yellow") ||
        type.toLowerCase().contains("card")) {
      iconPath = detail.toLowerCase().contains("red")
          ? IconAssets.red_card
          : IconAssets.yellow_card;
    } else if (type.toLowerCase() == "goal") {
      iconPath = IconAssets.soccer_icon;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$minute''",
            style: FontManager.bodyMedium(
                fontSize: 14, color: AppColors.textSecondary)),
        AppSpacing.w12,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(iconPath, height: 14.h, width: 14.h),
                AppSpacing.w8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(player, style: FontManager.bodyMedium(fontSize: 14)),
                      SizedBox(height: 2.h),
                      Text("$type - $detail",
                          style: FontManager.bodySmall(
                              color: AppColors.textSecondary)),
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

  /// Stat Row
  Widget _buildStatRow(String statName, int homeValue, int awayValue) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 1.w, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(homeValue.toString(),
                  style: FontManager.heading3(
                      color: AppColors.textPrimary, fontSize: 18)),
              Text(statName,
                  style: FontManager.labelMedium(
                      color: AppColors.textPrimary, fontSize: 14)),
              Text(awayValue.toString(),
                  style: FontManager.heading3(
                      color: AppColors.textPrimary, fontSize: 18)),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                flex: homeValue == 0 && awayValue == 0
                    ? 1
                    : (homeValue == 0 ? 0 : homeValue),
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
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
              Expanded(
                flex: homeValue == 0 && awayValue == 0
                    ? 1
                    : (awayValue == 0 ? 0 : awayValue),
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
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
