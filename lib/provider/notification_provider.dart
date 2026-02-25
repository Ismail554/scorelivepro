import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scorelivepro/services/notification_service.dart';
import 'package:scorelivepro/views/notification_views/models/notification_model.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/dio_service.dart';

class NotificationProvider extends ChangeNotifier {
  int _unreadCount = 0;
  bool _isLoading = false;

  List<NotificationModel> _notifications = [];
  bool _isLoadingNotifications = false;

  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  List<NotificationModel> get notifications => _notifications;
  bool get isLoadingNotifications => _isLoadingNotifications;

  /// Fetch unread notifications count
  Future<void> fetchUnreadCount() async {
    _isLoading = true;
    notifyListeners();

    try {
      final count = await NotificationService.getUnreadCount();
      if (count != null) {
        _unreadCount = count;
      }
    } catch (e) {
      debugPrint("Error fetching notification count: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update count manually (optimistic updates)
  void setUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }

  /// Fetch notifications inbox
  Future<void> fetchNotifications() async {
    _isLoadingNotifications = true;
    notifyListeners();

    try {
      final data = await NotificationService.getNotifications();
      if (data != null) {
        _notifications = data;
        _unreadCount = _notifications.where((n) => !n.isRead).length;
      }
    } catch (e) {
      debugPrint("Error fetching notifications list: $e");
    } finally {
      _isLoadingNotifications = false;
      notifyListeners();
    }
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = _notifications[index];
      _notifications[index] = NotificationModel(
        id: old.id,
        title: old.title,
        content: old.content,
        timestamp: old.timestamp,
        category: old.category,
        iconEmoji: old.iconEmoji,
        isRead: true,
        type: old.type,
      );
      if (_unreadCount > 0) _unreadCount--;
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    if (_unreadCount == 0 && _notifications.every((n) => n.isRead)) return;

    _notifications = _notifications.map((n) {
      return NotificationModel(
        id: n.id,
        title: n.title,
        content: n.content,
        timestamp: n.timestamp,
        category: n.category,
        iconEmoji: n.iconEmoji,
        isRead: true,
        type: n.type,
      );
    }).toList();
    _unreadCount = 0;
    notifyListeners();

    await NotificationService.markAllAsRead();
  }

  void deleteNotification(String id) {
    final notification = _notifications.firstWhere((n) => n.id == id,
        orElse: () => _notifications.first);
    if (notification.id == id) {
      if (!notification.isRead && _unreadCount > 0) {
        _unreadCount--;
      }
      _notifications.removeWhere((n) => n.id == id);
      notifyListeners();
    }
  }

  Future<bool> registerDevice(bool active) async {
    try {
      // 1. Fetch real FCM Token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint("Failed to get FCM token");
        return false;
      }

      // 2. Detect OS
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
