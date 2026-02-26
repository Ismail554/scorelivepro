import 'package:flutter/material.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/models/team_model.dart';
import 'package:scorelivepro/services/team_service.dart';

class TeamProvider extends ChangeNotifier {
  List<TeamModel> _teams = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String _searchQuery = '';

  List<TeamModel> get teams => _teams;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      fetchTeams(refresh: true);
    }
  }

  Future<void> fetchTeams({bool refresh = false}) async {
    if (refresh) {
      _teams = [];
      _currentPage = 1;
      _hasMore = true;
    } else {
      if (!_hasMore || _isLoading) return;
    }

    _isLoading = true;
    notifyListeners();

    final response =
        await TeamService.fetchTeams(page: _currentPage, search: _searchQuery);

    if (response != null) {
      if (response.results.isNotEmpty) {
        _teams.addAll(response.results);
        if (response.next != null) {
          _currentPage++;
        } else {
          _hasMore = false;
        }
      } else {
        _hasMore = false;
      }
    } else {
      _hasMore = false; // Stop pagination on error or empty response
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTeamToFavorites(
      int teamId, String teamName, BuildContext context) async {
    final error = await TeamService.addTeamToFavorites(teamId);
    if (context.mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "$teamName is added to favorites",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      } else {
        // Custom beautiful floating snackbar for any error (as requested)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "You must need to login for add teams to Favorite.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}
