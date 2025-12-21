import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/utils/navigation_helper.dart';
import 'package:scorelivepro/widget/leagues/widget_league_card.dart';
import 'package:scorelivepro/widget/leagues/widget_premium_upgrade_card.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/widget/navigation/custom_bottom_nav_bar.dart';

/// League model
class League {
  final String leagueName;
  final String countryOrRegion;
  final LeagueIconType iconType;
  final String? iconLabel;
  final String? flagEmoji;
  final String region; // For filtering

  const League({
    required this.leagueName,
    required this.countryOrRegion,
    required this.iconType,
    this.iconLabel,
    this.flagEmoji,
    required this.region,
  });
}

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  String _selectedRegion = "South America";
  final TextEditingController _searchController = TextEditingController();

  // Sample league data
  final List<League> _allLeagues = [
    // South America
    const League(
      leagueName: "Copa Libertadores",
      countryOrRegion: "South America",
      iconType: LeagueIconType.trophy,
      region: "South America",
    ),
    const League(
      leagueName: "Copa Sudamericana",
      countryOrRegion: "South America",
      iconType: LeagueIconType.medal,
      iconLabel: "2",
      region: "South America",
    ),
    const League(
      leagueName: "Brasileirão Série A",
      countryOrRegion: "Brazil",
      iconType: LeagueIconType.flag,
      flagEmoji: "🇧🇷",
      region: "South America",
    ),
    const League(
      leagueName: "Liga Profesional",
      countryOrRegion: "Argentina",
      iconType: LeagueIconType.flag,
      flagEmoji: "🇦🇷",
      region: "South America",
    ),
    const League(
      leagueName: "Categoría Primera A",
      countryOrRegion: "Colombia",
      iconType: LeagueIconType.flag,
      flagEmoji: "🇨🇴",
      region: "South America",
    ),
    const League(
      leagueName: "Primera División",
      countryOrRegion: "Chile",
      iconType: LeagueIconType.flag,
      flagEmoji: "🇨🇱",
      region: "South America",
    ),
    const League(
      leagueName: "Primera División",
      countryOrRegion: "Uruguay",
      iconType: LeagueIconType.flag,
      flagEmoji: "🇺🇾",
      region: "South America",
    ),
    const League(
      leagueName: "Serie A",
      countryOrRegion: "Ecuador",
      iconType: LeagueIconType.flag,
      flagEmoji: "🇪🇨",
      region: "South America",
    ),
    const League(
      leagueName: "Liga 1",
      countryOrRegion: "Peru",
      iconType: LeagueIconType.flag,
      flagEmoji: "🇵🇪",
      region: "South America",
    ),
    const League(
      leagueName: "Primera División",
      countryOrRegion: "Paraguay",
      iconType: LeagueIconType.flag,
      flagEmoji: "🇵🇾",
      region: "South America",
    ),
    // International
    const League(
      leagueName: "UEFA Champions League",
      countryOrRegion: "International",
      iconType: LeagueIconType.trophy,
      region: "International",
    ),
    const League(
      leagueName: "FIFA World Cup",
      countryOrRegion: "International",
      iconType: LeagueIconType.trophy,
      region: "International",
    ),
    // Asia
    const League(
      leagueName: "AFC Champions League",
      countryOrRegion: "Asia",
      iconType: LeagueIconType.trophy,
      region: "Asia",
    ),
    // North America
    const League(
      leagueName: "MLS",
      countryOrRegion: "United States",
      iconType: LeagueIconType.flag,
      flagEmoji: "🇺🇸",
      region: "North America",
    ),
  ];

  List<League> get _filteredLeagues {
    return _allLeagues
        .where((league) => league.region == _selectedRegion)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        AppStrings.leagues,
                        style: FontManager.heading2(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      NotificationBell(
                        hasNotification: true,
                        iconColor: AppColors.black,
                        onTap: () {},
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
                            decoration: InputDecoration(
                              hintText: "Search leagues...",
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

                  SizedBox(height: 16.h),

                  // Region Filter Chips
                  SizedBox(
                    height: 40.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildRegionChip("International"),
                        SizedBox(width: 8.w),
                        _buildRegionChip("South America"),
                        SizedBox(width: 8.w),
                        _buildRegionChip("Asia"),
                        SizedBox(width: 8.w),
                        _buildRegionChip("North America"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Leagues List
          Expanded(
            child: _filteredLeagues.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 64.sp,
                          color: AppColors.grey,
                        ),
                        AppSpacing.h16,
                        Text(
                          AppStrings.noLeagues,
                          style: FontManager.bodyLarge(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount:
                        _filteredLeagues.length + 1, // +1 for premium card
                    itemBuilder: (context, index) {
                      // Last item → premium upgrade card
                      if (index == _filteredLeagues.length) {
                        return PremiumUpgradeCard(
                          onUpgradeTap: () {
                            // TODO: Navigate to upgrade screen
                          },
                        );
                      }

                      final league = _filteredLeagues[index];
                      return LeagueCard(
                        leagueName: league.leagueName,
                        countryOrRegion: league.countryOrRegion,
                        iconType: league.iconType,
                        iconLabel: league.iconLabel,
                        flagEmoji: league.flagEmoji,
                        onTap: () {
                          // TODO: Navigate to league details
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionChip(String region) {
    final isSelected = _selectedRegion == region;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRegion = region;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.greyE8,
            width: 1.w,
          ),
        ),
        child: Text(
          region,
          style: FontManager.labelMedium(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
