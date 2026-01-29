import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class TeamService {
  /// Fetch all teams with pagination
  static Future<Map<String, dynamic>?> getAllTeams({int? page}) async {
    final Map<String, dynamic> queryParams = {};
    if (page != null) queryParams['page'] = page;

    final result = await DioManager.apiRequest(
      url: ApiEndPoint.getAllTeams(),
      methods: Methods.get,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      skipAuth: false,
    );

    return result.fold(
      (error) {
        return null;
      },
      (data) {
        if (data is Map<String, dynamic>) {
          print("I/flutter (14185): ✅ API SUCCESS [200]");
          print("I/flutter (14185): URL: ${ApiEndPoint.getAllTeams()}");
          print("I/flutter (14185): Response: $data");
          return data;
        }
        return null;
      },
    );
  }
}
