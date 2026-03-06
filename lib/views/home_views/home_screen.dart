import 'package:flutter/material.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/ads/banner_ad_widget.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/favorites_views/favorites_screen.dart';
import 'package:scorelivepro/views/home_views/live_mathches/live_match_details_screen.dart';
import 'package:scorelivepro/views/news_views/news_screen.dart';
import 'package:scorelivepro/widget/home/match_card.dart';
import 'package:scorelivepro/widget/home/quick_action_card.dart';
import 'package:scorelivepro/widget/home/section_header.dart';

import 'package:scorelivepro/utils/match_status_helper.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';

import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/match_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch fixtures on load for LiveMatchesScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchProvider>(context, listen: false).fetchFixtures();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            //Top bg part
            SizedBox(
              height: 180.h,
              width: double.maxFinite,
              child: Stack(
                children: [
                  /// Background Image
                  Positioned.fill(
                      child: Image.asset(
                    ImageAssets.home_bg,
                    fit: BoxFit.cover,
                  )),

                  /// 🌑 Dark overlay for readability
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

                  /// 🔔 Notification Bell (Top Right)
                  Positioned(
                    top: 45,
                    right: 16,
                    child: NotificationBell(hasNotification: true),
                  ),

                  /// 👋 Welcome Text (Bottom Left)
                  Positioned(
                    left: 16,
                    bottom: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).welcome_back,
                          style: FontManager.heading3(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, d MMM, yyyy',
                                  Localizations.localeOf(context).languageCode)
                              .format(DateTime.now()),
                          style: FontManager.heading4(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // end of top stack
            //body part
            Expanded(
              child: Container(
                color: AppColors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Live Matches Section
                      SectionHeader(
                        title: AppLocalizations.of(context).liveMatches,
                        onSeeAllTap: () {},
                      ),
                      Consumer<MatchProvider>(
                        builder: (context, provider, child) {
                          final matches = provider.liveMatches;

                          if (matches.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              child: Text(
                                AppLocalizations.of(context).noLiveMatches,
                                style: FontManager.bodyMedium(
                                    color: AppColors.textSecondary),
                              ),
                            );
                          }

                          // Show only top 2 matches
                          final displayMatches = matches.take(2).toList();

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: displayMatches.length,
                            itemBuilder: (context, index) {
                              final match = displayMatches[index];
                              return MatchCard(
                                leagueName: match.league?.name ??
                                    AppLocalizations.of(context).unknownLeague,
                                homeTeam: match.homeTeam?.name ??
                                    AppLocalizations.of(context).home,
                                awayTeam: match.awayTeam?.name ??
                                    AppLocalizations.of(context).away,
                                homeScore: match.goals?.home,
                                awayScore: match.goals?.away,
                                timeInfo: "${match.elapsed ?? 0}'",
                                status: MatchStatusHelper.getMatchStatus(
                                    match.statusShort),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LiveMatchDetailsScreen(
                                              matchData: match),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      AppSpacing.h8,

                      // Upcoming Matches Section
                      SectionHeader(
                        title: AppLocalizations.of(context).upcomingMatches,
                        onSeeAllTap: () {
                          // TODO: Navigate to upcoming matches screen
                        },
                      ),
                      Consumer<MatchProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoadingUpcoming &&
                              provider.upcomingMatches.isEmpty) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (provider.upcomingMatches.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              child: Text(
                                AppLocalizations.of(context).noUpcomingMatches,
                                style: FontManager.bodyMedium(
                                    color: AppColors.textSecondary),
                              ),
                            );
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
                                leagueName: match.league?.name ??
                                    AppLocalizations.of(context).unknownLeague,
                                homeTeam: match.homeTeam?.name ??
                                    AppLocalizations.of(context).home,
                                awayTeam: match.awayTeam?.name ??
                                    AppLocalizations.of(context).away,
                                timeInfo: match.date != null
                                    ? DateFormat('EEE, HH:mm').format(
                                        DateTime.parse(match.date!).toLocal())
                                    : AppLocalizations.of(context).upcoming,
                                status: MatchStatus.upcoming,
                                onTap: () {
                                  // TODO: Navigate to match details
                                },
                              );
                            },
                          );
                        },
                      ),
                      AppSpacing.h8,

                      // Quick Actions Section
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        child: Text(
                          AppLocalizations.of(context).quickActions,
                          style: FontManager.heading3(
                              color: AppColors.textPrimary),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          children: [
                            QuickActionCard(
                              icon: Icons.star,
                              title: AppLocalizations.of(context).myFavorites,
                              iconColor: AppColors.warning,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FavoritesScreen(),
                                    ));
                              },
                            ),
                            QuickActionCard(
                              icon: Icons.newspaper,
                              title: AppLocalizations.of(context).latestNews,
                              iconColor: AppColors.info,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NewsScreen(),
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.h16,

                      // Sponsored Ad Card
                      BannerAdWidget(),
                      AppSpacing.h16,
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
