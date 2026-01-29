import 'package:flutter/material.dart';
import 'package:scorelivepro/models/team_model.dart';
import 'package:scorelivepro/services/team_service.dart';

class TeamProvider extends ChangeNotifier {
  List<TeamModel> _teams = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  List<TeamModel> get teams => _teams;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

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

    final response = await TeamService.fetchTeams(page: _currentPage);

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
}
