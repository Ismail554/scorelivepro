import 'package:flutter/material.dart';

/// Notification Model
class NotificationModel {
  final String id;
  final String title;
  final String content;
  final String timestamp;
  final String category;
  final String iconEmoji; // Emoji for the notification icon
  final bool isRead;
  final NotificationType type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.category,
    required this.iconEmoji,
    this.isRead = false,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['body'] ?? '',
      timestamp: json['time_ago'] ?? '',
      category: json['event_type'] ?? '',
      iconEmoji: _getIconFromTitle(json['title']),
      isRead: json['is_read'] ?? false,
      type: _getTypeFromEvent(json['event_type']),
    );
  }

  static String _getIconFromTitle(String? title) {
    if (title != null && title.isNotEmpty) {
      final firstChar = title.characters.first;
      return firstChar;
    }
    return '🔔';
  }

  static NotificationType _getTypeFromEvent(String? eventType) {
    switch (eventType) {
      case 'MATCH_START':
        return NotificationType.match;
      default:
        return NotificationType.news;
    }
  }
}

/// Notification Type Enum
enum NotificationType {
  transfer,
  news,
  injury,
  match,
  league,
  team,
}
