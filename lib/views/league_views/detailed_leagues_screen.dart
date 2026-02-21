import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/utils/navigation_helper.dart';
import 'package:scorelivepro/widget/home/match_card.dart';
import 'package:scorelivepro/widget/leagues/widget_league_header_card.dart';
import 'package:scorelivepro/widget/leagues/widget_standings_team_card.dart';
import 'package:scorelivepro/widget/navigation/custom_bottom_nav_bar.dart';
import 'package:scorelivepro/widget/navigation/transparent_tab_bar.dart';
import 'package:scorelivepro/models/league_model.dart';
import 'package:scorelivepro/services/league_service.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchLeagueDetails();
  }

  Future<void> _fetchLeagueDetails() async {
    setState(() {
      _isLoading = true;
    });
    final details = await LeagueService.fetchLeagueDetails(widget.leagueId);
    if (mounted) {
      setState(() {
        _leagueDetails = details;
        _isLoading = false;
      });
    }
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
                  _isLoading
                      ? SizedBox(
                          height: 270.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                      : LeagueHeaderCard(
                          leagueName: _leagueDetails?.name ?? "Unknown League",
                          country: _leagueDetails?.country?.name ??
                              "Unknown Country",
                          season: "${_leagueDetails?.seasonYear ?? ""} Season",
                          logoUrl: _leagueDetails?.logo ??
                              _leagueDetails?.country?.flag,
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
                      tabs: const [
                        AppStrings.standings,
                        AppStrings.fixtures,
                        AppStrings.results,
                        AppStrings.teams,
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
                  _buildResultsTab(),
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
    // Sample standings data
    final standings = [
      {
        'rank': 1,
        'team': 'Manchester City',
        'points': 38,
        'played': 15,
        'wins': 12,
        'draws': 2,
        'losses': 1,
        'goalsFor': 38,
        'goalsAgainst': 12,
        'goalDifference': 26,
      },
      {
        'rank': 2,
        'team': 'Arsenal',
        'points': 36,
        'played': 15,
        'wins': 11,
        'draws': 3,
        'losses': 1,
        'goalsFor': 35,
        'goalsAgainst': 13,
        'goalDifference': 22,
      },
      {
        'rank': 3,
        'team': 'Liverpool',
        'points': 34,
        'played': 15,
        'wins': 10,
        'draws': 4,
        'losses': 1,
        'goalsFor': 32,
        'goalsAgainst': 15,
        'goalDifference': 17,
      },
      {
        'rank': 4,
        'team': 'Manchester United',
        'points': 30,
        'played': 15,
        'wins': 9,
        'draws': 3,
        'losses': 3,
        'goalsFor': 28,
        'goalsAgainst': 18,
        'goalDifference': 10,
      },
      {
        'rank': 5,
        'team': 'Newcastle',
        'points': 28,
        'played': 15,
        'wins': 8,
        'draws': 4,
        'losses': 3,
        'goalsFor': 27,
        'goalsAgainst': 17,
        'goalDifference': 10,
      },
      {
        'rank': 6,
        'team': 'Tottenham',
        'points': 27,
        'played': 15,
        'wins': 8,
        'draws': 3,
        'losses': 4,
        'goalsFor': 29,
        'goalsAgainst': 21,
        'goalDifference': 8,
      },
      {
        'rank': 7,
        'team': 'Chelsea',
        'points': 25,
        'played': 15,
        'wins': 7,
        'draws': 4,
        'losses': 4,
        'goalsFor': 24,
        'goalsAgainst': 19,
        'goalDifference': 5,
      },
      {
        'rank': 8,
        'team': 'Brighton',
        'points': 23,
        'played': 15,
        'wins': 6,
        'draws': 5,
        'losses': 4,
        'goalsFor': 22,
        'goalsAgainst': 20,
        'goalDifference': 2,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          AppSpacing.h12,
          // Standings List
          ...standings.map((team) {
            return StandingsTeamCard(
              rank: team['rank'] as int,
              teamName: team['team'] as String,
              points: team['points'] as int,
              played: team['played'] as int,
              wins: team['wins'] as int,
              draws: team['draws'] as int,
              losses: team['losses'] as int,
              goalsFor: team['goalsFor'] as int,
              goalsAgainst: team['goalsAgainst'] as int,
              goalDifference: team['goalDifference'] as int,
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

  /// Fixtures Tab Content (Upcoming Matches)
  Widget _buildFixturesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          AppSpacing.h12,
          // Upcoming Matches
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Manchester City",
            awayTeam: "Arsenal",
            timeInfo: "Today, 18:30",
            status: MatchStatus.upcoming,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Liverpool",
            awayTeam: "Chelsea",
            timeInfo: "Today, 20:00",
            status: MatchStatus.upcoming,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Manchester United",
            awayTeam: "Tottenham",
            timeInfo: "Tomorrow, 15:00",
            status: MatchStatus.upcoming,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Newcastle",
            awayTeam: "Brighton",
            timeInfo: "Tomorrow, 17:30",
            status: MatchStatus.upcoming,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Aston Villa",
            awayTeam: "West Ham",
            timeInfo: "Tomorrow, 19:45",
            status: MatchStatus.upcoming,
          ),
          MatchCard(
            leagueName: "Premier League",
            homeTeam: "Crystal Palace",
            awayTeam: "Fulham",
            timeInfo: "Sunday, 14:00",
            status: MatchStatus.upcoming,
          ),
          AppSpacing.h24,
        ],
      ),
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
    final teams = [
      "Manchester City",
      "Arsenal",
      "Liverpool",
      "Manchester United",
      "Newcastle",
      "Tottenham",
      "Chelsea",
      "Brighton",
      "Aston Villa",
      "West Ham",
      "Crystal Palace",
      "Fulham",
      "Everton",
      "Bournemouth",
      "Wolves",
      "Brentford",
      "Nottingham Forest",
      "Burnley",
      "Sheffield United",
      "Luton Town",
    ];

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      physics: const BouncingScrollPhysics(), // Smooth scrolling
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // এক লাইনে ২টা কার্ড
        crossAxisSpacing: 12.w, // ডানে-বামে গ্যাপ
        mainAxisSpacing: 12.h, // উপরে-নিচে গ্যাপ
        childAspectRatio:
            1.3, // কার্ডের সাইজ (Width / Height) - এটা কমালে কার্ড লম্বা হবে
      ),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius:
                BorderRadius.circular(16.r), // ছবির মতো রাউন্ডেড কর্নার
            border: Border.all(
              color: Colors.grey.shade200, // খুব হালকা বর্ডার
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03), // একদম হালকা শ্যাডো
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // সবকিছু সেন্টারে
            children: [
              // Team Logo (Circle or Image)
              // ছবির মতো রিয়েল লোগো না থাকলে প্লেসহোল্ডার
              Container(
                width: 80.w,
                height: 80.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star, // ডেমো আইকন, পরে ইমেজ দিও
                  size: 62.sp,
                  color: _getTeamColor(index), // জাস্ট একটু কালারফুল করার জন্য
                ),
              ),

              AppSpacing.h12, // লোগো আর নামের মাঝের গ্যাপ

              // Team Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  teams[index],
                  textAlign: TextAlign.center, // টেক্সট সেন্টারে থাকবে
                  style: FontManager.bodyMedium(
                    fontSize: 14, // ছবির ফন্ট সাইজ ছোট

                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2, // নাম বড় হলে ২ লাইনে যাবে
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // লোগোর জন্য একটা ডেমো কালার জেনারেটর (অপশনাল)
  Color _getTeamColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.teal,
      Colors.redAccent,
      Colors.black,
      Colors.indigo
    ];
    return colors[index % colors.length];
  }
}
