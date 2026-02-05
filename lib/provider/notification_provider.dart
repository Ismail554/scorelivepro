import 'package:flutter/material.dart';
import 'package:scorelivepro/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  int _unreadCount = 0;
  bool _isLoading = false;

  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

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
}
