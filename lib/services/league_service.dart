import 'package:scorelivepro/models/league_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class LeagueService {
  static Future<LeagueResponse?> fetchLeagues({
    int page = 1,
    String? search,
  }) async {
    String url = "${ApiEndPoint.getAllLeagues()}?page=$page";
    if (search != null && search.isNotEmpty) {
      url += "&search=$search";
    }

    final result = await DioManager.apiRequest(
      url: url,
      methods: Methods.get,
      skipAuth: true,
    );

    return result.fold(
      (error) => null,
      (data) {
        if (data is Map<String, dynamic>) {
          return LeagueResponse.fromJson(data);
        }
        return null;
      },
    );
  }

  static Future<String?> addLeagueToFavorites(int leagueId) async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.addToFavoriteLeaques(),
        methods: Methods.post,
        body: {"id": leagueId},
      );

      return response.fold(
        (error) {
          // debugPrint("Error adding league to favorites: $error");
          return error;
        },
        (data) => null,
      );
    } catch (e) {
      // debugPrint("Exception adding league to favorites: $e");
      return e.toString();
    }
  }

  static Future<String?> removeLeagueFromFavorites(int leagueId) async {
    try {
      print(
          "Calling API: ${ApiEndPoint.addToFavoriteLeaques()} (DELETE) - Removing League ID: $leagueId");
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.addToFavoriteLeaques(),
        methods: Methods.delete,
        body: {"id": leagueId},
      );

      return response.fold(
        (error) {
          print("Error Removing League from Favorites: $error");
          return error;
        },
        (data) {
          print("Success Removing League from Favorites: $data");
          return null;
        },
      );
    } catch (e) {
      print("Exception Removing League from Favorites: $e");
      return e.toString();
    }
  }

  static Future<List<LeagueModel>?> fetchFavoriteLeagues() async {
    try {
      print(
          "Calling API: ${ApiEndPoint.myFavoritesLeagues()} (GET) - Fetching Favorite Leagues");
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.myFavoritesLeagues(),
        methods: Methods.get,
        skipAuth: false,
      );

      return response.fold(
        (error) {
          print("Error Fetching Favorite Leagues: $error");
          return null;
        },
        (data) {
          print("Success Fetching Favorite Leagues: $data");
          if (data is List) {
            return data.map((e) => LeagueModel.fromJson(e)).toList();
          }
          if (data is Map<String, dynamic> && data['results'] != null) {
            return (data['results'] as List)
                .map((e) => LeagueModel.fromJson(e))
                .toList();
          }
          return [];
        },
      );
    } catch (e) {
      print("Exception Fetching Favorite Leagues: $e");
      return null;
    }
  }

  static Future<LeagueModel?> fetchLeagueDetails(int leagueId) async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.leagueDetails(leagueId),
        methods: Methods.get,
        skipAuth: true,
      );

      return response.fold(
        (error) {
          print("Error Fetching League Details: $error");
          return null;
        },
        (data) {
          if (data is Map<String, dynamic>) {
            return LeagueModel.fromJson(data);
          }
          return null;
        },
      );
    } catch (e) {
      print("Exception Fetching League Details: $e");
      return null;
    }
  }
}
