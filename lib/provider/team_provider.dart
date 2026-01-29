import 'package:flutter/foundation.dart';
import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:scorelivepro/services/team_service.dart';

class TeamProvider extends ChangeNotifier {
  List<HomeTeam> _teams = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;
  String? _nextPageUrl;

  List<HomeTeam> get teams => _teams;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  /// Fetch teams with pagination
  Future<void> fetchTeams({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _nextPageUrl = null;
      _teams.clear();
      _teams.clear();
      notifyListeners();
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await TeamService.getAllTeams(page: _currentPage);

      if (response != null) {
        final results = response['results'];
        _nextPageUrl = response['next'];

        if (results is List) {
          if (results.isEmpty) {
            _hasMore = false;
          } else {
            final newTeams = results.map((e) => HomeTeam.fromJson(e)).toList();
            _teams.addAll(newTeams);

            if (_nextPageUrl == null) {
              _hasMore = false;
            } else {
              _currentPage++;
            }
          }
        } else {
          _hasMore = false;
        }
      } else {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint("Error fetching teams: $e");
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
