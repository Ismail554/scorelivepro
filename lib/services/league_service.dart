import 'package:scorelivepro/models/league_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class LeagueService {
  static Future<LeagueResponse?> fetchLeagues({
    int page = 1,
    String? search,
  }) async {
    String url = "${ApiEndPoint.leagues}?page=$page";
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
}
