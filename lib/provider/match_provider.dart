import 'package:flutter/foundation.dart';
import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:scorelivepro/services/match_service.dart';

class MatchProvider extends ChangeNotifier {
  // Cache data by match ID
  final Map<int, List<Lineup>> _lineups = {};
  final Map<int, List<Statistic>> _statistics = {};
  final Map<int, bool> _isLoading = {};

  // Fixtures cache
  List<Data> _upcomingMatches = [];
  List<Data> _finishedMatches = [];
  bool _isLoadingFixtures = false;

  // Getters
  List<Lineup>? getLineups(int matchId) => _lineups[matchId];
  List<Statistic>? getStatistics(int matchId) => _statistics[matchId];
  bool isLoading(int matchId) => _isLoading[matchId] ?? false;

  List<Data> get upcomingMatches => _upcomingMatches;
  List<Data> get finishedMatches => _finishedMatches;
  bool get isLoadingFixtures => _isLoadingFixtures;

  /// Fetch both lineups and statistics for a match
  Future<void> fetchMatchDetails(int matchId, {bool isRefresh = false}) async {
    // If already loading and not a refresh, skip
    if (_isLoading[matchId] == true && !isRefresh) return;

    // Only set loading if not refreshing (keeps UI visible)
    if (!isRefresh) {
      _isLoading[matchId] = true;
      notifyListeners();
    }

    debugPrint("Fetching match details for matchId: $matchId");

    try {
      // Fetch concurrently
      final results = await Future.wait([
        MatchService.getMatchLineups(matchId),
        MatchService.getMatchStatistics(matchId),
      ]);

      final lineups = results[0] as List<Lineup>?;
      final stats = results[1] as List<Statistic>?;

      debugPrint("Fetched details for matchId: $matchId");
      if (lineups != null)
        debugPrint("   - Lineups data found: ${lineups.length} entries");
      if (stats != null)
        debugPrint("   - Statistics data found: ${stats.length} entries");

      if (lineups != null) {
        _lineups[matchId] = lineups;
      }

      if (stats != null) {
        _statistics[matchId] = stats;
      }
    } catch (e) {
      debugPrint("Error fetching match details: $e");
    } finally {
      _isLoading[matchId] = false;
      notifyListeners();
    }
  }

  /// Fetch all upcoming and finished matches
  Future<void> fetchFixtures() async {
    if (_isLoadingFixtures) return;

    _isLoadingFixtures = true;
    notifyListeners();

    try {
      final fixtures = await MatchService.getFixtures();

      if (fixtures != null) {
        _upcomingMatches.clear();
        _finishedMatches.clear();

        for (var match in fixtures) {
          final status = match.statusLong ?? "";
          if (status == "Not Started" || status == "Time to be defined") {
            _upcomingMatches.add(match);
          } else if (status == "Match Finished") {
            _finishedMatches.add(match);
          }
        }

        debugPrint(
            "Fetched Fixtures: Upcoming: ${_upcomingMatches.length}, Finished: ${_finishedMatches.length}");
      }
    } catch (e) {
      debugPrint("Error fetching fixtures: $e");
    } finally {
      _isLoadingFixtures = false;
      notifyListeners();
    }
  }

  /// Clear specific match data from cache (optional)
  void clearMatchData(int matchId) {
    _lineups.remove(matchId);
    _statistics.remove(matchId);
    _isLoading.remove(matchId);
    notifyListeners();
  }
}
