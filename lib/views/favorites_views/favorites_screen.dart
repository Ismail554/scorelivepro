import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/provider/team_provider.dart';
import 'package:scorelivepro/views/auth/login_screen.dart';
import 'package:scorelivepro/views/favorites_views/favorites_teams_screen.dart';
import 'package:scorelivepro/views/league_views/leagues_screen.dart';
import 'package:scorelivepro/ads/floating_banner_ad.dart';

import 'package:scorelivepro/widget/favorites/widget_favorite_league_card.dart';
import 'package:scorelivepro/widget/favorites/widget_favorite_team_card.dart';
import 'package:scorelivepro/widget/favorites/widget_sync_favorites_card.dart';
import 'package:scorelivepro/widget/favorites/confirmation_dialog.dart';
import 'package:scorelivepro/widget/custom_snackbar.dart';
import 'package:scorelivepro/widget/home/match_card.dart';
import 'package:scorelivepro/widget/home/section_header.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/provider/match_provider.dart';
import 'package:intl/intl.dart';
import 'package:scorelivepro/models/team_model.dart';
import 'package:scorelivepro/models/league_model.dart';
import 'package:scorelivepro/services/team_service.dart';
import 'package:scorelivepro/services/league_service.dart';
import 'package:scorelivepro/widget/shimmer_loading.dart';
import 'package:scorelivepro/widget/shimmer/match_card_shimmer.dart';
import 'package:scorelivepro/widget/common/no_internet_banner.dart';

class FavoritesScreen extends StatefulWidget {
  final bool showBackButton;
  const FavoritesScreen({super.key, this.showBackButton = false});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Data
  List<TeamModel> _favoriteTeams = [];
  List<LeagueModel> _favoriteLeagues = [];
  bool _isLoadingTeams = true;
  bool _isLoadingLeagues = true;
  bool _hasFetched = false;
  int _lastFavoriteVersion = 0;
  final GlobalKey<AnimatedListState> _teamsListKey =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _leaguesListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchFavorites() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      if (mounted) {
        setState(() {
          _isLoadingTeams = false;
          _isLoadingLeagues = false;
          _favoriteTeams = [];
          _favoriteLeagues = [];
          _hasFetched = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _hasFetched = true;
      });
    }
    _fetchTeams();
    _fetchLeagues();
  }

  Future<void> _fetchTeams() async {
    if (!mounted) return;
    setState(() => _isLoadingTeams = true);
    final response = await TeamService.fetchFavoriteTeams();
    if (mounted) {
      setState(() {
        _favoriteTeams = response ?? [];
        _isLoadingTeams = false;
      });
    }
  }

  Future<void> _fetchLeagues() async {
    if (!mounted) return;
    setState(() => _isLoadingLeagues = true);
    final response = await LeagueService.fetchFavoriteLeagues();
    if (mounted) {
      setState(() {
        _favoriteLeagues = response ?? [];
        _isLoadingLeagues = false;
      });
    }
  }

  Future<void> _removeTeam(int teamId) async {
    final index = _favoriteTeams.indexWhere((t) => t.id == teamId);
    if (index == -1) return;

    final team = _favoriteTeams[index];

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Remove Team?",
        message:
            "Are you sure you want to remove ${team.name} from your favorites?",
        confirmText: "Remove",
        isDestructive: true,
        onConfirm: () async {
          _teamsListKey.currentState?.removeItem(
            index,
            (context, animation) => SizeTransition(
              sizeFactor: animation,
              child: FavoriteTeamCard(
                teamName: team.name ?? 'Unknown',
                leagueName: '',
                logoUrl: team.logo,
                onDelete: null,
              ),
            ),
            duration: const Duration(milliseconds: 300),
          );

          setState(() {
            _favoriteTeams.removeAt(index);
          });

          final error = await TeamService.removeTeamFromFavorites(teamId);

          if (mounted) {
            if (error != null) {
              setState(() {
                _favoriteTeams.insert(index, team);
              });
              _teamsListKey.currentState?.insertItem(index);
              CustomSnackBar.show(
                  context: context, message: error, isError: true);
            } else {
              CustomSnackBar.show(
                  context: context,
                  message: "${team.name} removed successfully");
            }
          }
        },
      ),
    );
  }

  Future<void> _removeLeague(int leagueId) async {
    final index = _favoriteLeagues.indexWhere((l) => l.id == leagueId);
    if (index == -1) return;

    final league = _favoriteLeagues[index];

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Remove League?",
        message:
            "Are you sure you want to remove ${league.name} from your favorites?",
        confirmText: "Remove",
        isDestructive: true,
        onConfirm: () async {
          _leaguesListKey.currentState?.removeItem(
            index,
            (context, animation) => SizeTransition(
              sizeFactor: animation,
              child: FavoriteLeagueCard(
                leagueName: league.name ?? 'Unknown',
                countryName: league.country?.name ?? 'Unknown',
                logoUrl: league.logo,
                onDelete: null,
              ),
            ),
            duration: const Duration(milliseconds: 300),
          );

          setState(() {
            _favoriteLeagues.removeAt(index);
          });

          final error = await LeagueService.removeLeagueFromFavorites(leagueId);

          if (mounted) {
            if (error != null) {
              setState(() {
                _favoriteLeagues.insert(index, league);
              });
              _leaguesListKey.currentState?.insertItem(index);
              CustomSnackBar.show(
                  context: context, message: error, isError: true);
            } else {
              CustomSnackBar.show(
                  context: context,
                  message: "${league.name} removed successfully");
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          NoInternetBanner(
            child: Column(
              children: [
                // Header Section
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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
                          if (widget.showBackButton) ...[
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.greyE8,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 4.w),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors.textPrimary,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context).myFavorites,
                                  style: FontManager.heading2(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  AppLocalizations.of(context).manageFavorites,
                                  style: FontManager.bodySmall(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                        Consumer<AuthProvider>(builder: (context, auth, _) {
                          if (auth.isLoggedIn) {
                            if (!_hasFetched) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _fetchFavorites();
                              });
                            }
                            return const SizedBox.shrink();
                          }
                          return SyncFavoritesCard(
                            onLoginTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()));
                            },
                          );
                        }),

                        SectionHeader(
                          title: AppLocalizations.of(context).upcomingMatches,
                          onSeeAllTap: null,
                        ),
                        Consumer<MatchProvider>(
                          builder: (context, provider, child) {
                            if (provider.isLoadingUpcoming &&
                                provider.upcomingMatches.isEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: 2,
                                itemBuilder: (context, index) =>
                                    const MatchCardShimmer(),
                              );
                            }

                            if (provider.upcomingMatches.isEmpty) {
                              return const SizedBox.shrink();
                            }

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
                                  leagueName:
                                      match.league?.name ?? "Unknown League",
                                  homeTeam: match.homeTeam?.name ?? "Home",
                                  awayTeam: match.awayTeam?.name ?? "Away",
                                  homeTeamId: match.homeTeam?.id,
                                  awayTeamId: match.awayTeam?.id,
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
                        AppSpacing.h12,

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).favoriteTeams,
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
                                                  const FavoritesTeamsScreen(
                                                      showBackButton: true)))
                                      .then((_) => _fetchFavorites());
                                },
                                child: Text(
                                  AppLocalizations.of(context).addTeam,
                                  style: FontManager.bodySmall(
                                    color: AppColors.primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<TeamProvider>(
                          builder: (context, teamProvider, _) {
                            if (teamProvider.favoriteVersion >
                                _lastFavoriteVersion) {
                              _lastFavoriteVersion =
                                  teamProvider.favoriteVersion;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _fetchTeams();
                              });
                            }
                            return _buildTeamsList();
                          },
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).favoriteLeagues,
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
                                                  const LeaguesScreen(
                                                      showBackButton: true)))
                                      .then((_) => _fetchFavorites());
                                },
                                child: Text(
                                  AppLocalizations.of(context).addLeague,
                                  style: FontManager.bodySmall(
                                    color: AppColors.primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildLeaguesList(),
                        SizedBox(height: 60.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingBannerAd(),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsList() {
    if (_isLoadingTeams) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: const ShimmerLoading(
          itemCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      );
    }

    if (_favoriteTeams.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text(AppLocalizations.of(context).noFavoriteTeams,
            style: FontManager.bodyMedium(color: AppColors.textSecondary)),
      );
    }

    return AnimatedList(
      key: _teamsListKey,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      initialItemCount: _favoriteTeams.length,
      itemBuilder: (context, index, animation) {
        if (index >= _favoriteTeams.length) return const SizedBox.shrink();

        final team = _favoriteTeams[index];
        return SizeTransition(
          sizeFactor: animation,
          child: FavoriteTeamCard(
            teamName: team.name ?? 'Unknown',
            leagueName: '',
            logoUrl: team.logo,
            onDelete: () => _removeTeam(team.id),
          ),
        );
      },
    );
  }

  Widget _buildLeaguesList() {
    if (_isLoadingLeagues) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: const ShimmerLoading(
          itemCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      );
    }

    if (_favoriteLeagues.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Text(AppLocalizations.of(context).noFavoriteLeagues,
            style: FontManager.bodyMedium(color: AppColors.textSecondary)),
      );
    }

    return AnimatedList(
      key: _leaguesListKey,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      initialItemCount: _favoriteLeagues.length,
      itemBuilder: (context, index, animation) {
        if (index >= _favoriteLeagues.length) return const SizedBox.shrink();

        final league = _favoriteLeagues[index];
        return SizeTransition(
          sizeFactor: animation,
          child: FavoriteLeagueCard(
            leagueName: league.name ?? 'Unknown',
            countryName: league.country?.name ?? 'Unknown',
            logoUrl: league.logo,
            onDelete:
                league.id == null ? null : () => _removeLeague(league.id!),
          ),
        );
      },
    );
  }
}
