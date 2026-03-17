import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/utils/navigation_helper.dart';
import 'package:scorelivepro/views/home_views/live_mathches/lineups_screen.dart';
import 'package:scorelivepro/views/home_views/live_mathches/live_match_details_screen.dart';
import 'package:scorelivepro/widget/home/match_card.dart';
import 'package:scorelivepro/widget/home/sponsored_ad_card.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/widget/navigation/custom_bottom_nav_bar.dart';

import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:scorelivepro/utils/match_status_helper.dart';
import 'package:scorelivepro/provider/match_provider.dart';
import 'package:scorelivepro/widget/shimmer/match_card_shimmer.dart';

class LiveMatchesScreen extends StatefulWidget {
  const LiveMatchesScreen({super.key});

  @override
  State<LiveMatchesScreen> createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<TextEditingController> _searchControllers;

  /// Padding used around the tab bar – easy to tweak in one place
  late final EdgeInsets _tabPadding;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _searchControllers = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
    _tabPadding = EdgeInsets.symmetric(horizontal: 16.w);
    // Fixtures are now fetched in HomeScreen
  }

  @override
  void dispose() {
    for (var c in _searchControllers) {
      c.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).matches,
          style: FontManager.heading3(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: NotificationBell(
              hasNotification: true,
              iconColor: AppColors.black,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0, // Matches tab
        onTap: (index) {
          NavigationHelper.navigateToMainScreen(context, index);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildTabBar(),
          const SizedBox(height: 12),
          _buildCategoryChips(),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Consumer<MatchProvider>(
                  builder: (context, provider, child) {
                    return _buildRealLiveMatchesList(provider);
                  },
                ),

                // Upcoming Matches
                Consumer<MatchProvider>(
                  builder: (context, provider, child) {
                    return provider.isLoadingUpcoming &&
                            provider.upcomingMatches.isEmpty
                        ? _buildShimmerList()
                        : _buildRealMatchesList(provider.upcomingMatches,
                            isUpcoming: true);
                  },
                ),

                // Finished Matches
                Consumer<MatchProvider>(
                  builder: (context, provider, child) {
                    return provider.isLoadingFinished &&
                            provider.finishedMatches.isEmpty
                        ? _buildShimmerList()
                        : _buildRealMatchesList(provider.finishedMatches,
                            isUpcoming: false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- UI BUILDERS ----------------

  /// Category Chips Builder
  Widget _buildCategoryChips() {
    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final currentTabIndex = _tabController.index;
        final leagues = provider.getAvailableLeaguesForTab(currentTabIndex);
        if (leagues.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 38.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: leagues.length,
            itemBuilder: (context, index) {
              final leagueName = leagues[index];
              String selectedLeagueForTab = provider.selectedLeagueLive;
              if (currentTabIndex == 1) {
                selectedLeagueForTab = provider.selectedLeagueUpcoming;
              } else if (currentTabIndex == 2) {
                selectedLeagueForTab = provider.selectedLeagueFinished;
              }

              final isSelected = selectedLeagueForTab == leagueName;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: Text(leagueName),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setSelectedLeague(currentTabIndex, leagueName);
                    }
                  },
                  selectedColor: AppColors.primaryColor,
                  labelStyle: FontManager.bodyMedium(
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Shimmer loading list
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
        return const MatchCardShimmer();
      },
    );
  }

  /// ---------------- UI BUILDERS ----------------

  /// Top search bar
  Widget _buildSearchBar() {
    return Consumer<MatchProvider>(
      builder: (context, provider, child) {
        final currentTabIndex = _tabController.index;
        String currentQuery = '';

        if (currentTabIndex == 0) {
          currentQuery = provider.searchQueryLive;
        } else if (currentTabIndex == 1) {
          currentQuery = provider.searchQueryUpcoming;
        } else if (currentTabIndex == 2) {
          currentQuery = provider.searchQueryFinished;
        }

        final controller = _searchControllers[currentTabIndex];
        // Ensure controller text is in sync with provider (e.g. if cleared)
        if (controller.text != currentQuery) {
          controller.text = currentQuery;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    onChanged: (value) {
                      provider.setSearchQuery(currentTabIndex, value);
                    },
                    style: FontManager.bodyMedium(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).searchTeamNames,
                      hintStyle: FontManager.bodyMedium(
                        color: Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(bottom: 4.h), // aligns text with icon
                    ),
                  ),
                ),
                if (currentQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      controller.clear();
                      provider.setSearchQuery(currentTabIndex, '');
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.grey.shade500,
                      size: 18.sp,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Tab bar with Live / Upcoming / Finished
  Widget _buildTabBar() {
    return Padding(
      padding: _tabPadding,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.textPrimary,
          indicator: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelStyle: FontManager.labelMedium(fontSize: 14),
          unselectedLabelStyle: FontManager.labelMedium(fontSize: 14),
          tabs: [
            Tab(text: AppLocalizations.of(context).live),
            Tab(text: AppLocalizations.of(context).upcoming),
            Tab(text: AppLocalizations.of(context).finished),
          ],
        ),
      ),
    );
  }

  /// 🔹 Real Live Matches List from Socket
  Widget _buildRealLiveMatchesList(MatchProvider provider) {
    final matches = provider.liveMatches;

    if (matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer,
                size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            SizedBox(height: 16.h),
            Text(
              "No live matches currently",
              style: FontManager.bodyMedium(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
      itemCount: matches.length + 1, // +1 for sponsored card
      itemBuilder: (context, index) {
        // Last item → sponsored card
        if (index == matches.length) {
          return const SponsoredAdCard(onTryFreeTap: null);
        }

        final match = matches[index];
        return MatchCard(
          leagueName: match.league?.name ?? "Unknown League",
          homeTeam: match.homeTeam?.name ?? "Home",
          awayTeam: match.awayTeam?.name ?? "Away",
          homeScore: match.goals?.home,
          awayScore: match.goals?.away,
          timeInfo: "${match.elapsed ?? 0}'",
          status: MatchStatusHelper.getMatchStatus(match.statusShort),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveMatchDetailsScreen(matchData: match),
              ),
            );
          },
        );
      },
    );
  }

  /// Generic real matches builder for Upcoming/Finished
  Widget _buildRealMatchesList(List<Data> matches, {bool isUpcoming = false}) {
    if (matches.isEmpty) {
      return Center(
        child: Text(
          "No matches found",
          style: FontManager.bodyMedium(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
      itemCount: matches.length + 1, // +1 for sponsored card
      itemBuilder: (context, index) {
        // Last item → sponsored card
        if (index == matches.length) {
          return const SponsoredAdCard(onTryFreeTap: null);
        }

        final match = matches[index];
        return MatchCard(
          leagueName: match.league?.name ?? "Unknown League",
          homeTeam: match.homeTeam?.name ?? "Home",
          awayTeam: match.awayTeam?.name ?? "Away",
          homeScore: match.goals?.home,
          awayScore: match.goals?.away,
          timeInfo: isUpcoming
              ? (match.date != null
                  ? DateTime.parse(match.date!)
                      .toLocal()
                      .toString()
                      .substring(11, 16)
                  : "-")
              : "${match.elapsed ?? 90}'",
          status: MatchStatusHelper.getMatchStatus(match.statusShort),
          onTap: () {
            if (isUpcoming) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeLineupsScreen(
                    matchData: match,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LiveMatchDetailsScreen(matchData: match),
                ),
              );
            }
          },
        );
      },
    );
  }
}
