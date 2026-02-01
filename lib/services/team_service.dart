import 'package:flutter/foundation.dart';
import 'package:scorelivepro/models/team_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class TeamService {
  static Future<TeamResponse?> fetchTeams({int page = 1}) async {
    try {
      final response = await DioManager.apiRequest(
        url: "${ApiEndPoint.getAllTeams()}?page=$page",
        methods: Methods.get,
        skipAuth: true,
      );

      return response.fold(
        (error) {
          debugPrint("Error fetching teams: $error");
          return null;
        },
        (data) {
          if (data is Map<String, dynamic>) {
            return TeamResponse.fromJson(data);
          }
          return null;
        },
      );
    } catch (e) {
      debugPrint("Exception fetching teams: $e");
      return null;
    }
  }

  static Future<bool> addTeamToFavorites(int teamId) async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.addToFavoriteTeams(),
        methods: Methods.post,
        body: {"id": teamId},
      );

      return response.fold(
        (error) {
          debugPrint("Error adding team to favorites: $error");
          return false;
        },
        (data) => true,
      );
    } catch (e) {
      debugPrint("Exception adding team to favorites: $e");
      return false;
    }
  }
}
