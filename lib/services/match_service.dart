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
        // Check for direct object structure with 'home' and 'away' keys (New API pattern)
        if (data['home'] != null && data['away'] != null) {
          List<Lineup> lineups = [];
          lineups.add(Lineup.fromJson(data['home']));
          lineups.add(Lineup.fromJson(data['away']));
          return lineups;
        }

        // Check for 'data' first (User's custom API pattern)
        if (data['data'] != null && data['data'] is List) {
          List<Lineup> lineups = [];
          data['data'].forEach((v) {
            lineups.add(Lineup.fromJson(v));
          });
          return lineups;
        }

        // Check for 'response' (Standard API-Football pattern)
        if (data['response'] != null && data['response'] is List) {
          List<Lineup> lineups = [];
          data['response'].forEach((v) {
            lineups.add(Lineup.fromJson(v));
          });
          return lineups;
        }
        return null;
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
        if (data['data'] != null && data['data'] is List) {
          List<Statistic> stats = [];
          data['data'].forEach((v) {
            stats.add(Statistic.fromJson(v));
          });
          return stats;
        }

        // Fallback or if structure is different
        if (data['response'] != null && data['response'] is List) {
          List<Statistic> stats = [];
          data['response'].forEach((v) {
            stats.add(Statistic.fromJson(v));
          });
          return stats;
        }

        return null;
      },
    );
  }

  static Future<List<Data>?> getFixtures() async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.up_fin_matches,
      methods: Methods.get,
      skipAuth: true,
    );

    return result.fold(
      (error) => null,
      (data) {
        // Check if data is directly a List (Matches direct API response)
        if (data is List) {
          List<Data> fixtures = [];
          for (var v in data) {
            fixtures.add(Data.fromJson(v));
          }
          return fixtures;
        }

        if (data['data'] != null && data['data'] is List) {
          List<Data> fixtures = [];
          data['data'].forEach((v) {
            fixtures.add(Data.fromJson(v));
          });
          return fixtures;
        }

        if (data['response'] != null && data['response'] is List) {
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
