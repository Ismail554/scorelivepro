import 'package:scorelivepro/models/league_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class LeagueService {
  static Future<List<LeagueModel>?> fetchLeagues() async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.leagues,
      methods: Methods.get,
      skipAuth: true,
    );

    return result.fold(
      (error) => null,
      (data) {
        if (data is List) {
          return data.map((e) => LeagueModel.fromJson(e)).toList();
        } else if (data is Map && data.containsKey('data')) {
          // Handle potential wrapped response like { data: [...] }
          final list = data['data'];
          if (list is List) {
            return list.map((e) => LeagueModel.fromJson(e)).toList();
          }
        }
        return null; // Or empty list depending on preference
      },
    );
  }
}
