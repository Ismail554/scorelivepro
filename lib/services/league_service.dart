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
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.addToFavoriteLeaques(),
        methods: Methods.delete,
        body: {"id": leagueId},
      );

      return response.fold(
        (error) => error,
        (data) => null,
      );
    } catch (e) {
      return e.toString();
    }
  }

  static Future<LeagueResponse?> fetchFavoriteLeagues() async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiEndPoint.addToFavoriteLeaques(),
        methods: Methods.get,
        skipAuth: false,
      );

      return response.fold(
        (error) => null,
        (data) {
          if (data is Map<String, dynamic>) {
            return LeagueResponse.fromJson(data);
          }
          return null;
        },
      );
    } catch (e) {
      return null;
    }
  }
}
