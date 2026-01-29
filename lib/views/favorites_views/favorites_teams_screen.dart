import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/favorites/widget_team_browse_card.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/widget/shimmer_loading.dart';

import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/team_provider.dart';

// Removed BrowseTeam class as we use HomeTeam from model

class FavoritesTeamsScreen extends StatefulWidget {
  const FavoritesTeamsScreen({super.key});

  @override
  State<FavoritesTeamsScreen> createState() => _FavoritesTeamsScreenState();
}

class _FavoritesTeamsScreenState extends State<FavoritesTeamsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial teams
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeamProvider>(context, listen: false)
          .fetchTeams(refresh: true);
    });
    debugPrint("FavoritesTeamsScreen: initState completed");

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<TeamProvider>(context, listen: false).fetchTeams();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("FavoritesTeamsScreen: build called");
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Header Section
          Container(
            color: AppColors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 16.h,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // Title and Notification Bell
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.browseTeams,
                        style: FontManager.heading2(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      NotificationBell(
                        hasNotification: true,
                        iconColor: AppColors.black,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Search Bar
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.greyE8,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.textTertiary,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: "Search teams...",
                              hintStyle: FontManager.bodyMedium(
                                color: AppColors.textTertiary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: FontManager.bodyMedium(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Teams List
          Expanded(
            child: Consumer<TeamProvider>(
              builder: (context, provider, child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<TeamProvider>(context, listen: false)
                        .fetchTeams(refresh: true);
                  },
                  child: Builder(builder: (context) {
                    if (provider.isLoading && provider.teams.isEmpty) {
                      return const ShimmerLoading();
                    }

                    if (provider.teams.isEmpty) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: constraints.maxHeight,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.sports_soccer,
                                      size: 64.sp,
                                      color: AppColors.grey,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      AppStrings.noTeams,
                                      style: FontManager.bodyLarge(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount:
                          provider.teams.length + (provider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == provider.teams.length) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ));
                        }

                        final team = provider.teams[index];
                        return TeamBrowseCard(
                          teamName: team.name ?? 'Unknown',
                          leagueName: '', // No league data in response
                          isFavorited:
                              false, // Default false as API doesn't return state
                          logoUrl: team.logo,
                          // Favorites flow intentionally disabled for now
                          onFavoriteToggle: null,
                        );
                      },
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
