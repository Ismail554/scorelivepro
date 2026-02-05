import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class NotificationService {
  static Future<int?> getUnreadCount() async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.unreadNotificationsCount(),
      methods: Methods.get,
    );

    return result.fold(
      (error) => null,
      (data) {
        if (data != null && data is Map<String, dynamic>) {
          return data['unread_count'] as int?;
        }
        return 0;
      },
    );
  }
}
