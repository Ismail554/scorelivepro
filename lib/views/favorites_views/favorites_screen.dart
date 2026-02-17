import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/views/auth/login_screen.dart';
import 'package:scorelivepro/views/favorites_views/favorites_teams_screen.dart';
import 'package:scorelivepro/views/league_views/leagues_screen.dart';
import 'package:scorelivepro/views/notification_views/notification_all_screen.dart';
import 'package:scorelivepro/widget/favorites/widget_favorite_league_card.dart';
import 'package:scorelivepro/widget/favorites/widget_favorite_team_card.dart';
import 'package:scorelivepro/widget/favorites/widget_sync_favorites_card.dart';
import 'package:scorelivepro/widget/home/match_card.dart';
import 'package:scorelivepro/widget/home/section_header.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/provider/match_provider.dart';
import 'package:intl/intl.dart';

/// Favorite team model
class FavoriteTeam {
  final String teamName;
  final String leagueName;
  final bool notificationsEnabled;

  const FavoriteTeam({
    required this.teamName,
    required this.leagueName,
    this.notificationsEnabled = true,
  });
}

/// Favorite league model
class FavoriteLeague {
  final String leagueName;
  final String countryName;
  final String? countryFlag;
  final bool notificationsEnabled;

  const FavoriteLeague({
    required this.leagueName,
    required this.countryName,
    this.countryFlag,
    this.notificationsEnabled = true,
  });
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Sample data
  final List<FavoriteTeam> _favoriteTeams = [
    const FavoriteTeam(
      teamName: "Manchester City",
      leagueName: "Premier League",
      notificationsEnabled: true,
    ),
    const FavoriteTeam(
      teamName: "Real Madrid",
      leagueName: "La Liga",
      notificationsEnabled: true,
    ),
    const FavoriteTeam(
      teamName: "Inter Milan",
      leagueName: "Serie A",
      notificationsEnabled: false,
    ),
  ];

  final List<FavoriteLeague> _favoriteLeagues = [
    const FavoriteLeague(
      leagueName: "Premier League",
      countryName: "England",
      countryFlag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿",
      notificationsEnabled: true,
    ),
    const FavoriteLeague(
      leagueName: "La Liga",
      countryName: "Spain",
      countryFlag: "🇪🇸",
      notificationsEnabled: true,
    ),
    const FavoriteLeague(
      leagueName: "Serie A",
      countryName: "Italy",
      countryFlag: "🇮🇹",
      notificationsEnabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LEFT SIDE (TITLE + SUBTITLE)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.myFavorites,
                            style: FontManager.heading2(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Manage your favorite teams and leagues",
                            style: FontManager.bodySmall(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // RIGHT SIDE (NOTIFICATION)
                    NotificationBell(
                      hasNotification: true,
                      iconColor: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sync Favorites Card
                  Consumer<AuthProvider>(builder: (context, auth, _) {
                    if (auth.isLoggedIn) return const SizedBox.shrink();
                    return SyncFavoritesCard(
                      onLoginTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                    );
                  }),

                  // Upcoming Matches Section
                  SectionHeader(
                    title: AppStrings.upcomingMatches,
                    onSeeAllTap: null,
                  ),
                  Consumer<MatchProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoadingUpcoming &&
                          provider.upcomingMatches.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.upcomingMatches.isEmpty) {
                        // Optional: Hide section or show message
                        return const SizedBox.shrink();
                      }

                      // Show only top 2 matches
                      final upcomingDisplay =
                          provider.upcomingMatches.take(2).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: upcomingDisplay.length,
                        itemBuilder: (context, index) {
                          final match = upcomingDisplay[index];
                          return MatchCard(
                            leagueName: match.league?.name ?? "Unknown League",
                            homeTeam: match.homeTeam?.name ?? "Home",
                            awayTeam: match.awayTeam?.name ?? "Away",
                            // Display scores if available, else time
                            homeScore: match.goals?.home,
                            awayScore: match.goals?.away,
                            timeInfo: match.date != null
                                ? DateFormat('EEE, HH:mm').format(
                                    DateTime.parse(match.date!).toLocal())
                                : "Upcoming",
                            status: MatchStatus.upcoming,
                          );
                        },
                      );
                    },
                  ),
                  AppSpacing.h8,

                  // Favorite Teams Section
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.favoriteTeams,
                          style: FontManager.heading3(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FavoritesTeamsScreen()));
                          },
                          child: Text(
                            "+ Add Team",
                            style: FontManager.bodySmall(
                              color: AppColors.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _favoriteTeams.length,
                    itemBuilder: (context, index) {
                      final team = _favoriteTeams[index];
                      return FavoriteTeamCard(
                        teamName: team.teamName,
                        leagueName: team.leagueName,
                        notificationsEnabled: team.notificationsEnabled,
                        onNotificationToggle: () {
                          setState(() {
                            _favoriteTeams[index] = FavoriteTeam(
                              teamName: team.teamName,
                              leagueName: team.leagueName,
                              notificationsEnabled: !team.notificationsEnabled,
                            );
                          });
                        },
                        onDelete: () {
                          setState(() {
                            _favoriteTeams.removeAt(index);
                          });
                        },
                      );
                    },
                  ),

                  // Favorite Leagues Section
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.favoriteLeagues,
                          style: FontManager.heading3(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LeaguesScreen()));
                          },
                          child: Text(
                            "+ Add League",
                            style: FontManager.bodySmall(
                              color: AppColors.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _favoriteLeagues.length,
                    itemBuilder: (context, index) {
                      final league = _favoriteLeagues[index];
                      return FavoriteLeagueCard(
                        leagueName: league.leagueName,
                        countryName: league.countryName,
                        countryFlag: league.countryFlag,
                        notificationsEnabled: league.notificationsEnabled,
                        onNotificationToggle: () {
                          setState(() {
                            _favoriteLeagues[index] = FavoriteLeague(
                              leagueName: league.leagueName,
                              countryName: league.countryName,
                              countryFlag: league.countryFlag,
                              notificationsEnabled:
                                  !league.notificationsEnabled,
                            );
                          });
                        },
                        onDelete: () {
                          setState(() {
                            _favoriteLeagues.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
