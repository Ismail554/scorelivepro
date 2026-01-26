import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/models/league_model.dart';
import 'package:scorelivepro/services/league_service.dart';
import 'package:scorelivepro/views/league_views/detailed_leagues_screen.dart';
import 'package:scorelivepro/widget/leagues/widget_league_card.dart';
import 'package:scorelivepro/widget/leagues/widget_premium_upgrade_card.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LeagueModel> _allLeagues = [];
  List<LeagueModel> _filteredLeagues = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLeagues();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchLeagues() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final leagues = await LeagueService.fetchLeagues();
      if (leagues != null) {
        setState(() {
          _allLeagues = leagues;
          _filteredLeagues = leagues;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to load leagues";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLeagues = _allLeagues;
      } else {
        _filteredLeagues = _allLeagues.where((league) {
          final name = league.name?.toLowerCase() ?? '';
          final country = league.country?.name?.toLowerCase() ?? '';
          return name.contains(query) || country.contains(query);
        }).toList();
      }
    });
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
                ],
              ),
            ),
          ),

          // Leagues List
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _fetchLeagues,
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (_filteredLeagues.isEmpty) {
      return Center(
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
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: _filteredLeagues.length + 1, // +1 for premium card
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
          leagueName: league.name ?? "Unknown League",
          countryOrRegion: league.country?.name ?? "Unknown Country",
          logoUrl: league.logo,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailedLeaguesScreen()));
          },
        );
      },
    );
  }
}
