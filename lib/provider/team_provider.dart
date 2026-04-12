import 'package:flutter/material.dart';
import 'package:scorelivepro/models/team_model.dart';
import 'package:scorelivepro/services/team_service.dart';
import 'package:scorelivepro/widget/custom_snackbar.dart';

class TeamProvider extends ChangeNotifier {
  List<TeamModel> _teams = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String _searchQuery = '';
  int _favoriteVersion = 0;

  List<TeamModel> get teams => _teams;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;
  int get favoriteVersion => _favoriteVersion;

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
        _favoriteVersion++;
        notifyListeners();
        CustomSnackBar.show(
          context: context,
          message: "$teamName is added to favorites",
          isError: false,
        );
      } else {
        // Custom beautiful floating snackbar for any error (as requested)
        CustomSnackBar.show(
          context: context,
          message: "You must need to login for add teams to Favorite.",
          isError: true,
        );
      }
    }
  }
}
