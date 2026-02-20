import 'package:flutter/material.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';
import 'package:scorelivepro/views/notification_views/models/notification_model.dart';

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

  static Future<List<NotificationModel>?> getNotifications() async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.getNotifications(),
      methods: Methods.get,
    );

    return result.fold(
      (error) {
        debugPrint("Error fetching notifications: $error");
        return null;
      },
      (data) {
        if (data != null && data is List) {
          return data.map((json) => NotificationModel.fromJson(json)).toList();
        }
        return [];
      },
    );
  }

  static Future<bool> markAllAsRead() async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.markAllRead(),
      methods: Methods.post,
    );

    return result.fold(
      (error) {
        debugPrint("Error marking all notifications as read: $error");
        return false;
      },
      (data) {
        return true;
      },
    );
  }
}
