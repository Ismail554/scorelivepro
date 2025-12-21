import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/models/fake_data/live_match_details_fake_data.dart';
import 'package:scorelivepro/utils/navigation_helper.dart';
import 'package:scorelivepro/widget/home/match_card.dart';
import 'package:scorelivepro/widget/home/sponsored_ad_card.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/widget/navigation/custom_bottom_nav_bar.dart';

class LiveMatchesScreen extends StatefulWidget {
  const LiveMatchesScreen({super.key});

  @override
  State<LiveMatchesScreen> createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// Padding used around the tab bar – easy to tweak in one place
  late final EdgeInsets _tabPadding;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabPadding = EdgeInsets.symmetric(horizontal: 16.w);
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
          _buildDateCard(),
          _buildTabBar(),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMatchesList(kLiveMatchesFake),
                _buildMatchesList(kUpcomingMatchesFake),
                _buildMatchesList(kFinishedMatchesFake),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- UI BUILDERS ----------------

  /// Top date selector card
  Widget _buildDateCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey.shade600,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Today - Dec 1, 2025',
              style: FontManager.bodyMedium(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
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
          tabs: const [
            Tab(text: 'Live'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Finished'),
          ],
        ),
      ),
    );
  }

  /// Generic list builder used by all three tabs.
  /// Adds a sponsored card as the last item.
  Widget _buildMatchesList(List<LiveMatchFakeModel> matches) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: 12.h,
        bottom: 16.h,
      ),
      itemCount: matches.length + 1, // +1 for sponsored card
      itemBuilder: (context, index) {
        // Last item → sponsored card
        if (index == matches.length) {
          return const SponsoredAdCard(
            onTryFreeTap: null,
          );
        }

        final match = matches[index];
        return MatchCard(
          leagueName: match.leagueName,
          homeTeam: match.homeTeam,
          awayTeam: match.awayTeam,
          homeScore: match.homeScore,
          awayScore: match.awayScore,
          timeInfo: match.timeInfo,
          status: match.status,
        );
      },
    );
  }
}
