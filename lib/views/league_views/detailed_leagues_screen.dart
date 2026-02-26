import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/utils/navigation_helper.dart';
import 'package:scorelivepro/widget/home/match_card.dart';
import 'package:scorelivepro/widget/leagues/widget_league_header_card.dart';
import 'package:scorelivepro/widget/leagues/widget_standings_team_card.dart';
import 'package:scorelivepro/widget/navigation/custom_bottom_nav_bar.dart';
import 'package:scorelivepro/widget/navigation/transparent_tab_bar.dart';
import 'package:scorelivepro/models/league_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:scorelivepro/models/standings_model.dart';
import 'package:scorelivepro/models/team_model.dart';
import 'package:scorelivepro/models/live_ws_model.dart' as ws;
import 'package:scorelivepro/services/league_service.dart';
import 'package:scorelivepro/utils/match_status_helper.dart';
import 'package:scorelivepro/views/league_views/standing_details/detailed_standings_screen.dart';
import 'package:scorelivepro/widget/shimmer/match_card_shimmer.dart';

class DetailedLeaguesScreen extends StatefulWidget {
  final int leagueId;
  const DetailedLeaguesScreen({super.key, required this.leagueId});

  @override
  State<DetailedLeaguesScreen> createState() => _DetailedLeaguesScreenState();
}

class _DetailedLeaguesScreenState extends State<DetailedLeaguesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LeagueModel? _leagueDetails;
  bool _isLoading = true;
  List<StandingsModel>? _standings;
  bool _isStandingsLoading = true;
  List<TeamModel>? _teams;
  bool _isTeamsLoading = true;
  List<ws.Data>? _fixtures;
  bool _isFixturesLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchLeagueDetails();
  }

  Future<void> _fetchLeagueDetails() async {
    setState(() {
      _isLoading = true;
      _isStandingsLoading = true;
      _isTeamsLoading = true;
      _isFixturesLoading = true;
    });

    LeagueService.fetchLeagueDetails(widget.leagueId).then((details) {
      if (mounted) {
        setState(() {
          _leagueDetails = details;
          _isLoading = false;
        });
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    LeagueService.fetchLeagueStandings(widget.leagueId).then((standings) {
      if (mounted) {
        setState(() {
          _standings = standings;
          _isStandingsLoading = false;
        });
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _isStandingsLoading = false;
        });
      }
    });

    LeagueService.fetchLeagueTeams(widget.leagueId).then((teams) {
      if (mounted) {
        setState(() {
          _teams = teams;
          _isTeamsLoading = false;
        });
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _isTeamsLoading = false;
        });
      }
    });

    LeagueService.fetchLeagueFixtures(widget.leagueId).then((fixtures) {
      if (mounted) {
        setState(() {
          _fixtures = fixtures;
          _isFixturesLoading = false;
        });
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {
          _isFixturesLoading = false;
        });
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
                  // League Header Card
                  LeagueHeaderCard(
                    leagueName: _isLoading
                        ? "Loading..."
                        : (_leagueDetails?.name ?? "Unknown League"),
                    country: _isLoading
                        ? "Loading..."
                        : (_leagueDetails?.country?.name ?? "Unknown Country"),
                    season: _isLoading
                        ? "..."
                        : "${_leagueDetails?.seasonYear ?? ""} Season",
                    logoUrl:
                        _leagueDetails?.logo ?? _leagueDetails?.country?.flag,
                    onBackPressed: () => Navigator.pop(context),
                    hasNotification: false,
                  ),

                  // Transparent Tab Bar (overlaid at bottom)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TransparentTabBar(
                      tabController: _tabController,
                      tabs: [
                        AppLocalizations.of(context).standings,
                        AppLocalizations.of(context).fixtures,
                        AppLocalizations.of(context).teams,
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
                  _buildStandingsTab(),
                  _buildFixturesTab(),
                  // _buildResultsTab(),
                  _buildTeamsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Standings Tab Content
  Widget _buildStandingsTab() {
    if (_isStandingsLoading) {
      return ListView.builder(
        padding: EdgeInsets.only(top: 20.h),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade200, width: 1.w),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    AppSpacing.w12,
                    Expanded(
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          AppSpacing.w12,
                          Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 16.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 60.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.h16,
                Divider(color: Colors.grey.shade200, thickness: 1.h),
                AppSpacing.h16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                    (index) => Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 12.h,
                            width: 30.w,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 14.h,
                            width: 40.w,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    if (_standings == null || _standings!.isEmpty) {
      return Center(
        child: Text(
          "No standings available",
          style: FontManager.bodyLarge(color: AppColors.textSecondary),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          AppSpacing.h12,
          // Standings List
          ..._standings!.map((team) {
            return StandingsTeamCard(
              rank: team.rank ?? 0,
              teamName: team.team?.name ?? "Unknown",
              logoUrl: team.team?.logo,
              points: team.points ?? 0,
              played: team.all?.played ?? 0,
              wins: team.all?.win ?? 0,
              draws: team.all?.draw ?? 0,
              losses: team.all?.lose ?? 0,
              goalsFor: team.all?.goals?.goalsFor ?? 0,
              goalsAgainst: team.all?.goals?.goalsAgainst ?? 0,
              goalDifference: team.goalsDiff ?? 0,
            );
          }),

          AppSpacing.h24,

          // Legend
          Padding(
            padding: AppPadding.h16,
            child: Row(
              children: [
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                AppSpacing.w8,
                Text(
                  "Champions League",
                  style: FontManager.bodySmall(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.w24,
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                AppSpacing.w8,
                Text(
                  "Europa League",
                  style: FontManager.bodySmall(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.h24,
        ],
      ),
    );
  }

  /// Fixtures Tab Content (All Matches for League)
  Widget _buildFixturesTab() {
    if (_isFixturesLoading) {
      return ListView.builder(
        padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
        itemCount: 5,
        itemBuilder: (context, index) => const MatchCardShimmer(),
      );
    }

    if (_fixtures == null || _fixtures!.isEmpty) {
      return Center(
        child: Text(
          "No fixtures available",
          style: FontManager.bodyLarge(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h),
      itemCount: _fixtures!.length + 1,
      itemBuilder: (context, index) {
        if (index == _fixtures!.length) return AppSpacing.h24; // Bottom spacing

        final match = _fixtures![index];
        final matchStatus = MatchStatusHelper.getMatchStatus(match.statusShort);

        // Custom Time Parsing for `MatchCard` internal comma parsing
        String timeInfo = "-";
        if (match.date != null) {
          final localDate = DateTime.parse(match.date!).toLocal();
          final dateStr = localDate.toString().substring(0, 10);
          final timeStr = localDate.toString().substring(11, 16);
          timeInfo = "$dateStr, $timeStr";
        }

        // Ensure live matches override date with minutes elapsed
        if (matchStatus == MatchStatus.live) {
          timeInfo = "${match.elapsed ?? 90}'";
        }

        return MatchCard(
          leagueName: match.league?.name ?? _leagueDetails?.name ?? "Unknown",
          homeTeam: match.homeTeam?.name ?? "Home",
          awayTeam: match.awayTeam?.name ?? "Away",
          homeScore: match.goals?.home,
          awayScore: match.goals?.away,
          timeInfo: timeInfo,
          status: matchStatus,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedStandingsScreen(
                  teamName: match.homeTeam?.name ?? "Unknown",
                  rank: 0,
                  points: 0,
                  played: 0,
                  wins: 0,
                  draws: 0,
                  losses: 0,
                  goalsFor: match.goals?.home ?? 0,
                  goalsAgainst: match.goals?.away ?? 0,
                  goalDifference:
                      (match.goals?.home ?? 0) - (match.goals?.away ?? 0),
                  awayTeam: match.awayTeam?.name,
                  score:
                      "${match.goals?.home ?? '-'} - ${match.goals?.away ?? '-'}",
                  matchTime: timeInfo,
                  venue: match.venue?.name,
                  fixtureId: match.id,
                  homeTeamId: match.homeTeam?.id,
                  awayTeamId: match.awayTeam?.id,
                  leagueName:
                      match.league?.name ?? _leagueDetails?.name ?? "Unknown",
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Results Tab Content (Finished Matches)
  Widget _buildResultsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          AppSpacing.h12,
          // Finished Matches
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Manchester City",
            awayTeam: "Arsenal",
            homeScore: 2,
            awayScore: 2,
            timeInfo: "Yesterday",
            status: MatchStatus.finished,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Liverpool",
            awayTeam: "Chelsea",
            homeScore: 3,
            awayScore: 1,
            timeInfo: "Yesterday",
            status: MatchStatus.finished,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Manchester United",
            awayTeam: "Tottenham",
            homeScore: 1,
            awayScore: 0,
            timeInfo: "Yesterday",
            status: MatchStatus.finished,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Newcastle",
            awayTeam: "Brighton",
            homeScore: 2,
            awayScore: 2,
            timeInfo: "2 days ago",
            status: MatchStatus.finished,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Aston Villa",
            awayTeam: "West Ham",
            homeScore: 4,
            awayScore: 1,
            timeInfo: "2 days ago",
            status: MatchStatus.finished,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Crystal Palace",
            awayTeam: "Fulham",
            homeScore: 0,
            awayScore: 1,
            timeInfo: "3 days ago",
            status: MatchStatus.finished,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Everton",
            awayTeam: "Bournemouth",
            homeScore: 2,
            awayScore: 3,
            timeInfo: "3 days ago",
            status: MatchStatus.finished,
          ),
          AppSpacing.h24,
        ],
      ),
    );
  }

  /// Teams Tab Content (Grid View)
  Widget _buildTeamsTab() {
    if (_isTeamsLoading) {
      return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1.3,
        ),
        itemCount: 8, // Shimmer items count
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade200, width: 1.w),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                AppSpacing.h12,
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 100.w,
                    height: 14.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    if (_teams == null || _teams!.isEmpty) {
      return Center(
        child: Text(
          "No teams available",
          style: FontManager.bodyLarge(color: AppColors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.3,
      ),
      itemCount: _teams!.length,
      itemBuilder: (context, index) {
        final team = _teams![index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade200, width: 1.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Team Logo
              Container(
                width: 80.w,
                height: 80.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: team.logo != null && team.logo!.isNotEmpty
                    ? Image.network(
                        team.logo!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.shield, size: 62.sp, color: Colors.grey),
                      )
                    : Icon(Icons.shield, size: 62.sp, color: Colors.grey),
              ),

              AppSpacing.h12,

              // Team Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  team.name ?? "Unknown",
                  textAlign: TextAlign.center,
                  style: FontManager.bodyMedium(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
