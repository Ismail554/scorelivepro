import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/models/league_model.dart';
import 'package:scorelivepro/services/league_service.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/views/league_views/detailed_leagues_screen.dart';
import 'package:scorelivepro/widget/leagues/widget_league_card.dart';
import 'package:scorelivepro/widget/leagues/widget_premium_upgrade_card.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';
import 'package:scorelivepro/widget/favorites/widget_add_to_favorites_dialog.dart';
import 'package:scorelivepro/core/assets_manager.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<LeagueModel> _allLeagues = [];
  List<LeagueModel> _filteredLeagues = [];
  Set<int> _favoritedLeagueIds = {}; // Track favorited league IDs
  bool _isLoading = true;
  bool _isMoreLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchLeagues();
    _fetchFavorites(); // Fetch favorites on init
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isMoreLoading &&
        _hasMore) {
      _loadMoreLeagues();
    }
  }

  Timer? _debounce;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchLeagues();
    });
  }

  Future<void> _fetchFavorites() async {
    final response = await LeagueService.fetchFavoriteLeagues();
    if (response != null && mounted) {
      setState(() {
        _favoritedLeagueIds = response.map((e) => e.id!).toSet();
      });
    }
  }

  Future<void> _showAddFavoriteDialog(LeagueModel league) async {
    showDialog(
      context: context,
      builder: (context) => AddToFavoritesDialog(
        id: league.id!,
        name: league.name ?? "Unknown League",
        subtitle: league.country?.name ?? "Unknown Country",
        logo: league.logo != null
            ? Image.network(
                league.logo!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  IconAssets.soccer_icon, // Fallback icon
                  fit: BoxFit.contain,
                ),
              )
            : Image.asset(
                IconAssets.soccer_icon,
                fit: BoxFit.contain,
              ),
        isLeague: true,
        onSave: () {
          // Optimistically update UI or refresh
          setState(() {
            _favoritedLeagueIds.add(league.id!);
          });
        },
      ),
    );
  }

  Future<void> _toggleFavorite(int leagueId, String leagueName) async {
    // This method is kept if we want direct toggle removal,
    // but for adding we use the dialog now.
    // However, the user request says "implement... through the popup".
    // So if it IS favorited, maybe we just remove it directly?
    // Or do we show dialog even for removal? usually dialog is for "Add".
    // Let's assume:
    // If NOT favorited -> Show Dialog to Add
    // If Favorited -> Remove directly (toggle behavior)

    final isFavorited = _favoritedLeagueIds.contains(leagueId);

    if (!isFavorited) {
      // Find league object
      final league =
          _allLeagues.firstWhere((element) => element.id == leagueId);
      _showAddFavoriteDialog(league);
      return;
    }

    // Is favorited -> Remove directly
    String? error;
    setState(() {
      _favoritedLeagueIds.remove(leagueId);
    });

    print(
        "CALLING API: ${ApiEndPoint.addToFavoriteLeaques()} with ID: $leagueId (DELETE)");
    error = await LeagueService.removeLeagueFromFavorites(leagueId);

    if (error != null) {
      // Revert on error
      setState(() {
        _favoritedLeagueIds.add(leagueId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$leagueName removed from favorites"),
            backgroundColor: Colors.grey,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> _fetchLeagues() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPage = 1;
      _allLeagues.clear();
      _filteredLeagues.clear();
      _hasMore = true; // Reset hasMore on new search
    });

    try {
      final query = _searchController.text.trim();
      final response = await LeagueService.fetchLeagues(
        page: 1,
        search: query.isNotEmpty ? query : null,
      );

      if (response != null) {
        setState(() {
          _allLeagues = response.results;
          _filteredLeagues = List.from(_allLeagues);
          _hasMore = response.next != null;
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

  Future<void> _loadMoreLeagues() async {
    if (_isMoreLoading || !_hasMore) return; // Add guard clause

    setState(() {
      _isMoreLoading = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final query = _searchController.text.trim();

      final response = await LeagueService.fetchLeagues(
        page: nextPage,
        search: query.isNotEmpty ? query : null,
      );

      if (response != null) {
        setState(() {
          _currentPage = nextPage;
          _allLeagues.addAll(response.results);
          _filteredLeagues =
              List.from(_allLeagues); // No filtering needed, API does it
          _hasMore = response.next != null;
          _isMoreLoading = false;
        });
      } else {
        setState(() {
          _isMoreLoading = false;
          // Don't set hasMore to false on error, allow retry
        });
      }
    } catch (e) {
      setState(() {
        _isMoreLoading = false;
      });
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
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: _filteredLeagues.length + 1 + (_isMoreLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // Loading indicator at the bottom
        if (index == _filteredLeagues.length + 1) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Premium upgrade card (now at second to last position if loading)
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
          isFavorited: _favoritedLeagueIds.contains(league.id),
          onFavoriteToggle: () =>
              _toggleFavorite(league.id!, league.name ?? "League"),
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
