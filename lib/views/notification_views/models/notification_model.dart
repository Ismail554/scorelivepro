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

