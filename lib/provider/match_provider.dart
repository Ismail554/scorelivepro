import 'package:flutter/foundation.dart';
import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:scorelivepro/services/match_service.dart';
import 'package:scorelivepro/services/socket_service.dart';

class MatchProvider extends ChangeNotifier {
  // Cache data by match ID
  final Map<int, List<Lineup>> _lineups = {};
  final Map<int, List<Statistic>> _statistics = {};
  final Map<int, bool> _isLoading = {};

  // Live Socket Data Cache
  final Map<int, Data> _activeMatches = {};

  MatchProvider() {
    _initSocket();
  }

  void _initSocket() {
    // Connect to socket (token not used currently per service implementation)
    SocketService.instance.connectSocket("");
    SocketService.instance.liveScoreNotifier.addListener(_onSocketUpdate);
  }

  void _onSocketUpdate() {
    final update = SocketService.instance.liveScoreNotifier.value;
    if (update != null && update.data != null) {
      bool hasChanges = false;
      for (var matchData in update.data!) {
        if (matchData.id != null) {
          _activeMatches[matchData.id!] = matchData;
          hasChanges = true;
        }
      }

      if (hasChanges) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    SocketService.instance.liveScoreNotifier.removeListener(_onSocketUpdate);
    // Optional: SocketService.instance.disconnect();
    // We might not want to disconnect if other parts use it, but for now MatchProvider is the main user.
    super.dispose();
  }

  // Fixtures cache
  List<Data> _upcomingMatches = [];
  List<Data> _finishedMatches = [];
  bool _isLoadingUpcoming = false;
  bool _isLoadingFinished = false;

  // Pagination State
  int _upcomingPage = 1;
  int _finishedPage = 1;
  bool _hasMoreUpcoming = true;
  bool _hasMoreFinished = true;

  // Getters
  List<Lineup>? getLineups(int matchId) => _lineups[matchId];
  List<Statistic>? getStatistics(int matchId) => _statistics[matchId];
  bool isLoading(int matchId) => _isLoading[matchId] ?? false;

  /// Get the latest match data from socket cache or return null
  Data? getMatch(int matchId) => _activeMatches[matchId];

  List<Data> get upcomingMatches => _upcomingMatches;
  List<Data> get finishedMatches => _finishedMatches;
  bool get isLoadingFixtures => _isLoadingUpcoming || _isLoadingFinished;
  bool get isLoadingUpcoming => _isLoadingUpcoming;
  bool get isLoadingFinished => _isLoadingFinished;
  bool get hasMoreUpcoming => _hasMoreUpcoming;
  bool get hasMoreFinished => _hasMoreFinished;

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

  /// Fetch upcoming matches with pagination
  Future<void> fetchUpcomingMatches({bool refresh = false}) async {
    debugPrint(
        "🏆 [MatchProvider] fetchUpcomingMatches called. Refresh: $refresh, Page: $_upcomingPage");
    if (refresh) {
      _upcomingPage = 1;
      _hasMoreUpcoming = true;
      _upcomingMatches.clear();
    }

    if (_isLoadingUpcoming || !_hasMoreUpcoming) {
      debugPrint(
          "🏆 [MatchProvider] fetchUpcomingMatches skipped. IsLoading: $_isLoadingUpcoming, HasMore: $_hasMoreUpcoming");
      return;
    }

    _isLoadingUpcoming = true;
    notifyListeners();

    try {
      debugPrint("🏆 [MatchProvider] Awaiting API for upcoming...");
      final fixtures =
          await MatchService.getUpcomingMatches(page: _upcomingPage);

      if (fixtures != null) {
        debugPrint(
            "🏆 [MatchProvider] Fetched ${fixtures.length} upcoming matches.");
        if (fixtures.isEmpty) {
          _hasMoreUpcoming = false;
        } else {
          _upcomingMatches.addAll(fixtures);
          _upcomingPage++;
        }
      } else {
        debugPrint(
            "🏆 [MatchProvider] getFixtures returned null for upcoming.");
        _hasMoreUpcoming = false;
      }
    } catch (e, stack) {
      debugPrint("🏆 [MatchProvider] Error fetching upcoming fixtures: $e");
      debugPrint("🏆 [MatchProvider] Stack: $stack");
    } finally {
      debugPrint(
          "🏆 [MatchProvider] Finished fetchUpcomingMatches, setting isLoading to false.");
      _isLoadingUpcoming = false;
      notifyListeners();
    }
  }

  /// Fetch finished matches with pagination
  Future<void> fetchFinishedMatches({bool refresh = false}) async {
    debugPrint(
        "🏆 [MatchProvider] fetchFinishedMatches called. Refresh: $refresh, Page: $_finishedPage");
    if (refresh) {
      _finishedPage = 1;
      _hasMoreFinished = true;
      _finishedMatches.clear();
    }

    if (_isLoadingFinished || !_hasMoreFinished) {
      debugPrint(
          "🏆 [MatchProvider] fetchFinishedMatches skipped. IsLoading: $_isLoadingFinished, HasMore: $_hasMoreFinished");
      return;
    }

    _isLoadingFinished = true;
    notifyListeners();

    try {
      debugPrint("🏆 [MatchProvider] Awaiting API for finished...");
      final fixtures =
          await MatchService.getFinishedMatches(page: _finishedPage);

      if (fixtures != null) {
        debugPrint(
            "🏆 [MatchProvider] Fetched ${fixtures.length} finished matches.");
        if (fixtures.isEmpty) {
          _hasMoreFinished = false;
        } else {
          _finishedMatches.addAll(fixtures);
          _finishedPage++;
        }
      } else {
        debugPrint(
            "🏆 [MatchProvider] getFixtures returned null for finished.");
        _hasMoreFinished = false;
      }
    } catch (e, stack) {
      debugPrint("🏆 [MatchProvider] Error fetching finished fixtures: $e");
      debugPrint("🏆 [MatchProvider] Stack: $stack");
    } finally {
      debugPrint(
          "🏆 [MatchProvider] Finished fetchFinishedMatches, setting isLoading to false.");
      _isLoadingFinished = false;
      notifyListeners();
    }
  }

  /// Fetch initial data
  Future<void> fetchFixtures() async {
    debugPrint("🏆 [MatchProvider] fetchFixtures (All) started...");
    await Future.wait([
      fetchUpcomingMatches(refresh: true),
      fetchFinishedMatches(refresh: true),
    ]);
    debugPrint("🏆 [MatchProvider] fetchFixtures (All) completed!");
  }

  /// Clear specific match data from cache (optional)
  void clearMatchData(int matchId) {
    _lineups.remove(matchId);
    _statistics.remove(matchId);
    _isLoading.remove(matchId);
    notifyListeners();
  }
}
