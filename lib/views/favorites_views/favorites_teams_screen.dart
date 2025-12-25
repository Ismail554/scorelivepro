import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/favorites/widget_add_to_favorites_dialog.dart';
import 'package:scorelivepro/widget/favorites/widget_favorite_snackbar.dart';
import 'package:scorelivepro/widget/favorites/widget_team_browse_card.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';

/// Team model for browse teams
class BrowseTeam {
  final String teamName;
  final String leagueName;
  bool isFavorited;

  BrowseTeam({
    required this.teamName,
    required this.leagueName,
    this.isFavorited = false,
  });
}

class FavoritesTeamsScreen extends StatefulWidget {
  const FavoritesTeamsScreen({super.key});

  @override
  State<FavoritesTeamsScreen> createState() => _FavoritesTeamsScreenState();
}

class _FavoritesTeamsScreenState extends State<FavoritesTeamsScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Sample team data
  final List<BrowseTeam> _allTeams = [
    BrowseTeam(teamName: 'Manchester City', leagueName: 'Premier League', isFavorited: true),
    BrowseTeam(teamName: 'Arsenal', leagueName: 'Premier League'),
    BrowseTeam(teamName: 'Liverpool', leagueName: 'Premier League'),
    BrowseTeam(teamName: 'Chelsea', leagueName: 'Premier League'),
    BrowseTeam(teamName: 'Tottenham', leagueName: 'Premier League'),
    BrowseTeam(teamName: 'Manchester United', leagueName: 'Premier League'),
    BrowseTeam(teamName: 'Newcastle United', leagueName: 'Premier League'),
    BrowseTeam(teamName: 'Brighton', leagueName: 'Premier League'),
    BrowseTeam(teamName: 'Real Madrid', leagueName: 'La Liga', isFavorited: true),
    BrowseTeam(teamName: 'Barcelona', leagueName: 'La Liga'),
    BrowseTeam(teamName: 'Atletico Madrid', leagueName: 'La Liga'),
    BrowseTeam(teamName: 'Sevilla', leagueName: 'La Liga'),
    BrowseTeam(teamName: 'Real Sociedad', leagueName: 'La Liga'),
    BrowseTeam(teamName: 'Villarreal', leagueName: 'La Liga'),
    BrowseTeam(teamName: 'Inter Milan', leagueName: 'Serie A', isFavorited: true),
    BrowseTeam(teamName: 'AC Milan', leagueName: 'Serie A'),
    BrowseTeam(teamName: 'Juventus', leagueName: 'Serie A'),
    BrowseTeam(teamName: 'Napoli', leagueName: 'Serie A'),
    BrowseTeam(teamName: 'Roma', leagueName: 'Serie A'),
    BrowseTeam(teamName: 'Lazio', leagueName: 'Serie A'),
    BrowseTeam(teamName: 'Bayern Munich', leagueName: 'Bundesliga'),
    BrowseTeam(teamName: 'Borussia Dortmund', leagueName: 'Bundesliga'),
    BrowseTeam(teamName: 'RB Leipzig', leagueName: 'Bundesliga'),
    BrowseTeam(teamName: 'Bayer Leverkusen', leagueName: 'Bundesliga'),
    BrowseTeam(teamName: 'Union Berlin', leagueName: 'Bundesliga'),
    BrowseTeam(teamName: 'PSG', leagueName: 'Ligue 1'),
    BrowseTeam(teamName: 'AS Monaco', leagueName: 'Ligue 1'),
    BrowseTeam(teamName: 'Marseille', leagueName: 'Ligue 1'),
    BrowseTeam(teamName: 'Lyon', leagueName: 'Ligue 1'),
    BrowseTeam(teamName: 'Lille', leagueName: 'Ligue 1'),
  ];

  List<BrowseTeam> get _filteredTeams {
    var filtered = _allTeams;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((team) => team.leagueName == _selectedCategory).toList();
    }

    // Filter by search query
    final searchQuery = _searchController.text;
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((team) {
        return team.teamName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            team.leagueName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddToFavoritesDialog(BrowseTeam team) {
    showDialog(
      context: context,
      builder: (context) => AddToFavoritesDialog(
        teamName: team.teamName,
        leagueName: team.leagueName,
        onSave: () {
          setState(() {
            team.isFavorited = true;
          });
          // Show snackbar
          FavoriteSnackbar.show(context, team.teamName);
        },
        onMaybeLater: () {
          // Do nothing, just close dialog
        },
      ),
    );
  }

  void _handleFavoriteToggle(BrowseTeam team) {
    if (team.isFavorited) {
      // Remove from favorites
      setState(() {
        team.isFavorited = false;
      });
    } else {
      // Show add to favorites dialog
      _showAddToFavoritesDialog(team);
    }
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
                        AppStrings.browseTeams,
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

                  SizedBox(height: 16.h),

                  // Category Filter Chips
                  SizedBox(
                    height: 40.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip('All'),
                        SizedBox(width: 8.w),
                        _buildCategoryChip('Premier League'),
                        SizedBox(width: 8.w),
                        _buildCategoryChip('La Liga'),
                        SizedBox(width: 8.w),
                        _buildCategoryChip('Serie A'),
                        SizedBox(width: 8.w),
                        _buildCategoryChip('Bundesliga'),
                        SizedBox(width: 8.w),
                        _buildCategoryChip('Ligue 1'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Teams List
          Expanded(
            child: _filteredTeams.isEmpty
                ? Center(
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
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: _filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = _filteredTeams[index];
                      return TeamBrowseCard(
                        teamName: team.teamName,
                        leagueName: team.leagueName,
                        isFavorited: team.isFavorited,
                        onFavoriteToggle: () => _handleFavoriteToggle(team),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
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
          category,
          style: FontManager.labelMedium(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
