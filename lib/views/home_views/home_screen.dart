import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/home_views/live_mathches/live_match_details_screen.dart';
import 'package:scorelivepro/widget/home/match_card.dart';
import 'package:scorelivepro/widget/home/quick_action_card.dart';
import 'package:scorelivepro/widget/home/section_header.dart';
import 'package:scorelivepro/widget/home/sponsored_ad_card.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// 🔔 Notification Bell (Top Right)
                  Positioned(
                    top: 45,
                    right: 16,
                    child: NotificationBell(
                      hasNotification: true,
                    ),
                  ),

                  /// 👋 Welcome Text (Bottom Left)
                  Positioned(
                    left: 16,
                    bottom: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.welcome_back,
                          style: FontManager.heading3(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(AppStrings.date_today,
                            style: FontManager.heading4(color: Colors.white)),
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
                        title: AppStrings.liveMatches,
                        onSeeAllTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LiveMatchDetailsScreen()));
                        },
                      ),
                      MatchCard(
                        leagueName: 'Premier League',
                        homeTeam: 'Manchester United',
                        awayTeam: 'Liverpool',
                        homeScore: 2,
                        awayScore: 1,
                        timeInfo: "67'",
                        status: MatchStatus.live,
                      ),
                      MatchCard(
                        leagueName: 'La Liga',
                        homeTeam: 'Real Madrid',
                        awayTeam: 'Barcelona',
                        homeScore: 1,
                        awayScore: 1,
                        timeInfo: "45+2'",
                        status: MatchStatus.halfTime,
                        onTap: () {
                          // TODO: Navigate to match details
                        },
                      ),
                      AppSpacing.h8,

                      // Upcoming Matches Section
                      SectionHeader(
                        title: AppStrings.upcomingMatches,
                        onSeeAllTap: () {
                          // TODO: Navigate to upcoming matches screen
                        },
                      ),
                      MatchCard(
                        leagueName: 'Bundesliga',
                        homeTeam: 'Bayern Munich',
                        awayTeam: 'Borussia Dortmund',
                        timeInfo: 'Today, 18:30',
                        status: MatchStatus.upcoming,
                        onTap: () {
                          // TODO: Navigate to match details
                        },
                      ),
                      MatchCard(
                        leagueName: 'Ligue 1',
                        homeTeam: 'PSG',
                        awayTeam: 'Marseille',
                        timeInfo: 'Today, 20:45',
                        status: MatchStatus.upcoming,
                        onTap: () {
                          // TODO: Navigate to match details
                        },
                      ),
                      AppSpacing.h8,

                      // Quick Actions Section
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        child: Text(
                          'Quick Actions',
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
                              title: AppStrings.myFavorites,
                              iconColor: AppColors.warning,
                              onTap: () {
                                // TODO: Navigate to favorites screen
                              },
                            ),
                            QuickActionCard(
                              icon: Icons.newspaper,
                              title: AppStrings.latestNews,
                              iconColor: AppColors.info,
                              onTap: () {
                                // TODO: Navigate to news screen
                              },
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.h16,

                      // Sponsored Ad Card
                      SponsoredAdCard(
                        onTryFreeTap: () {
                          // TODO: Handle try free action
                        },
                      ),
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
