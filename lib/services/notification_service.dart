import 'dart:io';
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

  static Future<bool> deleteNotification(int id) async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.deleteNotification(id),
      methods: Methods.delete,
    );

    return result.fold(
      (error) {
        debugPrint("Error deleting notification: $error");
        return false;
      },
      (data) {
        return true;
      },
    );
  }

  static Future<bool> testPushNotification(String token) async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.testToken(token),
      methods: Methods.get,
    );

    return result.fold(
      (error) {
        debugPrint("Error testing push notification: $error");
        return false;
      },
      (data) {
        debugPrint("Test push notification triggered successfully");
        return true;
      },
    );
  }

  static Future<bool> updateNotificationSettings(
      bool receiveLiveNotifications, bool receiveNewsUpdates) async {
    final result = await DioManager.apiRequest(
      url: ApiEndPoint.notificationToggle(
          receiveLiveNotifications, receiveNewsUpdates),
      methods: Methods.patch,
      body: {
        "receive_live_notifications": receiveLiveNotifications,
        "receive_news_updates": receiveNewsUpdates,
      },
    );

    return result.fold(
      (error) {
        debugPrint("Error updating notification settings: $error");
        return false;
      },
      (data) {
        return true;
      },
    );
  }

  static Future<bool> registerDevice(String fcmToken, bool active) async {
    try {
      String osType = Platform.isAndroid ? 'android' : 'ios';

      final result = await DioManager.apiRequest(
        url: ApiEndPoint.registerDevice(),
        methods: Methods.post,
        body: {
          "registration_id": fcmToken,
          "type": osType,
          "active": active,
        },
      );

      return result.fold(
        (error) {
          debugPrint("Error registering device notifications: $error");
          return false;
        },
        (data) {
          debugPrint(
              "Successfully registered device notifications ($osType): $active");
          return true;
        },
      );
    } catch (e) {
      debugPrint("Exception registering device: $e");
      return false;
    }
  }
}
