import 'package:flutter/foundation.dart';
import 'package:scorelivepro/models/team_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class TeamService {
  static Future<TeamResponse?> fetchTeams(
      {int page = 1, String? search}) async {
    try {
      String url = "${ApiEndPoint.getAllTeams()}?page=$page";
      if (search != null && search.isNotEmpty) {
        url += "&search=$search";
      }

      final response = await DioManager.apiRequest(
        url: url,
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

  static Future<String?> addTeamToFavorites(int teamId) async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.addToFavoriteTeams(),
        methods: Methods.post,
        body: {"id": teamId},
      );

      return response.fold(
        (error) {
          debugPrint("Error adding team to favorites: $error");
          return error;
        },
        (data) => null,
      );
    } catch (e) {
      debugPrint("Exception adding team to favorites: $e");
      return e.toString();
    }
  }

  static Future<List<TeamModel>?> fetchFavoriteTeams() async {
    try {
      print(
          "Calling API: ${ApiEndPoint.myFavoritesTeam()} (GET) - Fetching Favorite Teams");
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.myFavoritesTeam(),
        methods: Methods.get,
        skipAuth: false,
      );

      return response.fold(
        (error) {
          print("Error Fetching Favorite Teams: $error");
          return null;
        },
        (data) {
          print("Success Fetching Favorite Teams: $data");
          if (data is List) {
            return data.map((e) => TeamModel.fromJson(e)).toList();
          }
          if (data is Map<String, dynamic> && data['results'] != null) {
            return (data['results'] as List)
                .map((e) => TeamModel.fromJson(e))
                .toList();
          }
          return [];
        },
      );
    } catch (e) {
      print("Exception Fetching Favorite Teams: $e");
      return null;
    }
  }

  static Future<String?> removeTeamFromFavorites(int teamId) async {
    try {
      print(
          "Calling API: ${ApiEndPoint.myFavoritesTeam()} (DELETE) - Removing Team ID: $teamId");
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.myFavoritesTeam(),
        methods: Methods.delete,
        body: {"id": teamId},
      );

      return response.fold(
        (error) {
          print("Error Removing Team from Favorites: $error");
          return error;
        },
        (data) {
          print("Success Removing Team from Favorites: $data");
          return null;
        },
      );
    } catch (e) {
      print("Exception Removing Team from Favorites: $e");
      return e.toString();
    }
  }
}
