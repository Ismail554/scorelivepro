import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/home/match_card.dart';
import 'package:scorelivepro/widget/home/sponsored_ad_card.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';

class LiveMatchesScreen extends StatefulWidget {
  const LiveMatchesScreen({super.key});

  @override
  State<LiveMatchesScreen> createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppStrings.matches,
          style: FontManager.heading3(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.h),
            child: NotificationBell(
              hasNotification: true,
              iconColor: AppColors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date card
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: AppColors.grey,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Today - Dec 1, 2025',
                  style: FontManager.bodyMedium(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                labelStyle: FontManager.labelMedium(
                  fontSize: 14,
                  color: AppColors.white,
                ),
                unselectedLabelStyle: FontManager.labelMedium(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                tabs: const [
                  Tab(text: 'Live'),
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Finished'),
                ],
              ),
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLiveTab(),
                _buildUpcomingTab(),
                _buildFinishedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          MatchCard(
            leagueName: 'Premier League',
            homeTeam: 'Manchester City',
            awayTeam: 'Arsenal',
            homeScore: 2,
            awayScore: 2,
            timeInfo: "78'",
            status: MatchStatus.live,
          ),
          MatchCard(
            leagueName: 'La Liga',
            homeTeam: 'Real Madrid',
            awayTeam: 'Atletico Madrid',
            homeScore: 3,
            awayScore: 1,
            timeInfo: "82'",
            status: MatchStatus.live,
          ),
          MatchCard(
            leagueName: 'Serie A',
            homeTeam: 'Inter Milan',
            awayTeam: 'AC Milan',
            homeScore: 1,
            awayScore: 0,
            timeInfo: "45+1'",
            status: MatchStatus.halfTime,
          ),
          SponsoredAdCard(
            onTryFreeTap: () {
              // TODO: Handle try free action
            },
          ),
          AppSpacing.h16,
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          MatchCard(
            leagueName: 'Bundesliga',
            homeTeam: 'Bayern Munich',
            awayTeam: 'Borussia Dortmund',
            timeInfo: 'Today, 18:30',
            status: MatchStatus.upcoming,
          ),
          MatchCard(
            leagueName: 'Ligue 1',
            homeTeam: 'PSG',
            awayTeam: 'Marseille',
            timeInfo: 'Today, 20:45',
            status: MatchStatus.upcoming,
          ),
          MatchCard(
            leagueName: 'Premier League',
            homeTeam: 'Chelsea',
            awayTeam: 'Tottenham',
            timeInfo: 'Tomorrow, 15:00',
            status: MatchStatus.upcoming,
          ),
          SponsoredAdCard(
            onTryFreeTap: () {
              // TODO: Handle try free action
            },
          ),
          AppSpacing.h16,
        ],
      ),
    );
  }

  Widget _buildFinishedTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          MatchCard(
            leagueName: 'Premier League',
            homeTeam: 'Liverpool',
            awayTeam: 'Manchester United',
            homeScore: 3,
            awayScore: 1,
            timeInfo: 'Yesterday, 17:00',
            status: MatchStatus.finished,
          ),
          MatchCard(
            leagueName: 'La Liga',
            homeTeam: 'Barcelona',
            awayTeam: 'Valencia',
            homeScore: 2,
            awayScore: 0,
            timeInfo: 'Yesterday, 19:30',
            status: MatchStatus.finished,
          ),
          MatchCard(
            leagueName: 'Serie A',
            homeTeam: 'Juventus',
            awayTeam: 'Napoli',
            homeScore: 1,
            awayScore: 1,
            timeInfo: 'Dec 30, 20:00',
            status: MatchStatus.finished,
          ),
          SponsoredAdCard(
            onTryFreeTap: () {
              // TODO: Handle try free action
            },
          ),
          AppSpacing.h16,
        ],
      ),
    );
  }
}
