import 'package:flutter/foundation.dart';
import 'package:scorelivepro/models/live_ws_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class MatchService {
  static Future<List<Lineup>?> getMatchLineups(int matchId) async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.lineups(matchId),
      methods: Methods.get,
      skipAuth: true,
    );

    return result.fold(
      (error) => null,
      (data) {
        try {
          // 🛡️ Safety Check: If data is a List (e.g. empty list [] when no data), return null
          if (data is List) {
            if (data.isEmpty) {
              return []; // Return empty list instead of null if preferred
            }
            return null;
          }

          // Ensure data is a Map before accessing keys
          if (data is! Map) return null;

          // Check for direct object structure with 'home' and 'away' keys (New API pattern)
          if (data['home'] != null && data['away'] != null) {
            // Validate that home and away are actually Maps
            if (data['home'] is Map && data['away'] is Map) {
              List<Lineup> lineups = [];
              lineups.add(Lineup.fromJson(data['home']));
              lineups.add(Lineup.fromJson(data['away']));
              return lineups;
            }
          }

          // Check for 'data' first (User's custom API pattern)
          if (data['data'] != null && data['data'] is List) {
            List<Lineup> lineups = [];
            for (var v in data['data']) {
              if (v is Map<String, dynamic>) {
                lineups.add(Lineup.fromJson(v));
              } else if (v is Map) {
                // Cast if it's a generic Map
                lineups.add(Lineup.fromJson(Map<String, dynamic>.from(v)));
              }
            }
            return lineups;
          }

          // Check for 'response' (Standard API-Football pattern)
          if (data['response'] != null && data['response'] is List) {
            List<Lineup> lineups = [];
            for (var v in data['response']) {
              if (v is Map<String, dynamic>) {
                lineups.add(Lineup.fromJson(v));
              } else if (v is Map) {
                // Cast if it's a generic Map
                lineups.add(Lineup.fromJson(Map<String, dynamic>.from(v)));
              }
            }
            return lineups;
          }
          return null;
        } catch (e) {
          debugPrint("Error parsing lineups: $e");
          return null;
        }
      },
    );
  }

  static Future<List<Statistic>?> getMatchStatistics(int matchId) async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.statistics(matchId),
      methods: Methods.get,
      skipAuth: true,
    );

    return result.fold(
      (error) => null,
      (data) {
        try {
          // 🛡️ Safety Check: If data is a List (e.g. empty list [] when no data), return null
          if (data is List) {
            if (data.isEmpty) return [];
            return null;
          }

          // Ensure data is a Map before accessing keys
          if (data is! Map) return null;

          if (data['data'] != null && data['data'] is List) {
            List<Statistic> stats = [];
            for (var v in data['data']) {
              if (v is Map<String, dynamic>) {
                stats.add(Statistic.fromJson(v));
              } else if (v is Map) {
                stats.add(Statistic.fromJson(Map<String, dynamic>.from(v)));
              }
            }
            return stats;
          }

          // Fallback or if structure is different
          if (data['response'] != null && data['response'] is List) {
            List<Statistic> stats = [];
            for (var v in data['response']) {
              if (v is Map<String, dynamic>) {
                stats.add(Statistic.fromJson(v));
              } else if (v is Map) {
                stats.add(Statistic.fromJson(Map<String, dynamic>.from(v)));
              }
            }
            return stats;
          }

          return null;
        } catch (e) {
          debugPrint("Error parsing statistics: $e");
          return null;
        }
      },
    );
  }

  static Future<List<Data>?> getUpcomingMatches(
      {int? page, String? date}) async {
    String url = ApiEndPoint.upcomingMatches;
    if (page != null) {
      url += "&page=$page";
    }
    if (date != null) {
      url += "&date=$date";
    }

    debugPrint("🏆 [MatchService] Attempting to fetch Upcoming Matches: $url");

    final result = await DioManager.apiRequest(
      url: url,
      methods: Methods.get,
      skipAuth:
          true, // Turned skipAuth from true to false since the API returned 401 token errors
    );

    return result.fold(
      (error) {
        debugPrint("🏆 [MatchService] Error from Upcoming Matches: $error");
        return null;
      },
      (data) {
        // 1. Handle new pagination structure with 'results' key
        if (data is Map && data.containsKey('results')) {
          final results = data['results'];
          if (results is List) {
            List<Data> fixtures = [];
            for (var v in results) {
              fixtures.add(Data.fromJson(v));
            }
            return fixtures;
          }
        }

        // 2. Handle direct list (Old behavior fallback)
        if (data is List) {
          List<Data> fixtures = [];
          for (var v in data) {
            fixtures.add(Data.fromJson(v));
          }
          return fixtures;
        }

        // 3. Handle 'data' wrapper (Another common pattern)
        if (data is Map && data['data'] != null && data['data'] is List) {
          List<Data> fixtures = [];
          data['data'].forEach((v) {
            fixtures.add(Data.fromJson(v));
          });
          return fixtures;
        }

        // 4. Handle 'response' wrapper (API-Football standard)
        if (data is Map &&
            data['response'] != null &&
            data['response'] is List) {
          List<Data> fixtures = [];
          data['response'].forEach((v) {
            fixtures.add(Data.fromJson(v));
          });
          return fixtures;
        }
        return null;
      },
    );
  }

  static Future<List<Data>?> getFinishedMatches(
      {int? page, String? date}) async {
    String url = ApiEndPoint.finishedMatches;
    if (page != null) {
      url += "&page=$page";
    }
    if (date != null) {
      url += "&date=$date";
    }

    debugPrint("🏆 [MatchService] Attempting to fetch Finished Matches: $url");

    final result = await DioManager.apiRequest(
      url: url,
      methods: Methods.get,
      skipAuth:
          true, // Turned skipAuth from true to false since the API returned 401 token errors
    );

    return result.fold(
      (error) {
        debugPrint("🏆 [MatchService] Error from Finished Matches: $error");
        return null;
      },
      (data) {
        // 1. Handle new pagination structure with 'results' key
        if (data is Map && data.containsKey('results')) {
          final results = data['results'];
          if (results is List) {
            List<Data> fixtures = [];
            for (var v in results) {
              fixtures.add(Data.fromJson(v));
            }
            return fixtures;
          }
        }

        // 2. Handle direct list (Old behavior fallback)
        if (data is List) {
          List<Data> fixtures = [];
          for (var v in data) {
            fixtures.add(Data.fromJson(v));
          }
          return fixtures;
        }

        // 3. Handle 'data' wrapper (Another common pattern)
        if (data is Map && data['data'] != null && data['data'] is List) {
          List<Data> fixtures = [];
          data['data'].forEach((v) {
            fixtures.add(Data.fromJson(v));
          });
          return fixtures;
        }

        // 4. Handle 'response' wrapper (API-Football standard)
        if (data is Map &&
            data['response'] != null &&
            data['response'] is List) {
          List<Data> fixtures = [];
          data['response'].forEach((v) {
            fixtures.add(Data.fromJson(v));
          });
          return fixtures;
        }
        return null;
      },
    );
  }
}
