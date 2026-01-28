import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/notification_provider.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/notification_views/models/notification_model.dart';
import 'package:scorelivepro/widget/notifications/widget_notification_card.dart';

class NotificationAllScreen extends StatefulWidget {
  const NotificationAllScreen({super.key});

  @override
  State<NotificationAllScreen> createState() => _NotificationAllScreenState();
}

class _NotificationAllScreenState extends State<NotificationAllScreen> {
  // Sample notifications data
  List<NotificationModel> _notifications = [
    const NotificationModel(
      id: '1',
      title: '🔥 Transfer Alert!',
      content:
          'PSG preparing €120M bid for Premier League midfielder. Breaking news!',
      timestamp: '4 hours ago',
      category: 'Ligue 1',
      iconEmoji: '🔥',
      isRead: false,
      type: NotificationType.transfer,
    ),
    const NotificationModel(
      id: '2',
      title: '📰 Premier League Update',
      content: 'New VAR changes announced for next season. Read full details.',
      timestamp: '5 hours ago',
      category: 'Premier League',
      iconEmoji: '📰',
      isRead: true,
      type: NotificationType.news,
    ),
    const NotificationModel(
      id: '3',
      title: '🚑 Injury Update',
      content: 'Star striker ruled out for 3 months. Major blow for the team.',
      timestamp: '6 hours ago',
      category: 'Premier League',
      iconEmoji: '🚑',
      isRead: false,
      type: NotificationType.injury,
    ),
    const NotificationModel(
      id: '4',
      title: '⚽ Match Started',
      content: 'Manchester United vs Liverpool - Match has begun!',
      timestamp: '1 day ago',
      category: 'Premier League',
      iconEmoji: '⚽',
      isRead: true,
      type: NotificationType.match,
    ),
    const NotificationModel(
      id: '5',
      title: '🏆 League Update',
      content: 'Premier League standings updated after latest matches.',
      timestamp: '2 days ago',
      category: 'Premier League',
      iconEmoji: '🏆',
      isRead: true,
      type: NotificationType.league,
    ),
    const NotificationModel(
      id: '6',
      title: '👥 Team News',
      content: 'New signing confirmed for Manchester City.',
      timestamp: '3 days ago',
      category: 'Premier League',
      iconEmoji: '👥',
      isRead: true,
      type: NotificationType.team,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Notifications List
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return NotificationCard(
                          notification: notification,
                          onDelete: () => _deleteNotification(notification.id),
                          onTap: () => _markAsRead(notification.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header with Back Button, Title, Actions
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            color: AppColors.textPrimary,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),

          SizedBox(width: 8.w),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.notifications,
                  style: FontManager.heading2(
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 18.sp,
                      color: AppColors.primaryLight,
                    ),
                    SizedBox(width: 4.w),
                    Consumer<NotificationProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          '${provider.unreadCount} unread notifications',
                          style: FontManager.bodySmall(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // Bell Icon with Unread Count (Compact)

          SizedBox(width: 8.w),

          // Mark All Read Button (Compact - Icon only or short text)
          GestureDetector(
            onTap: _markAllAsRead,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 18.sp,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    'Mark all read',
                    style: FontManager.labelMedium(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 4.w),

          // Settings Icon
          // IconButton(
          //   icon: const Icon(Icons.settings_outlined),
          //   onPressed: () {
          //     // TODO: Navigate to notification settings
          //   },
          //   color: AppColors.textPrimary,
          //   iconSize: 20.sp,
          //   constraints: const BoxConstraints(),
          //   padding: EdgeInsets.all(8.w),
          // ),
        ],
      ),
    );
  }

  /// Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64.sp,
            color: AppColors.grey,
          ),
          AppSpacing.h16,
          Text(
            AppStrings.noNotifications,
            style: FontManager.bodyLarge(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Mark notification as read
  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          id: _notifications[index].id,
          title: _notifications[index].title,
          content: _notifications[index].content,
          timestamp: _notifications[index].timestamp,
          category: _notifications[index].category,
          iconEmoji: _notifications[index].iconEmoji,
          isRead: true,
          type: _notifications[index].type,
        );
      }
    });
  }

  /// Mark all notifications as read
  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((notification) {
        return NotificationModel(
          id: notification.id,
          title: notification.title,
          content: notification.content,
          timestamp: notification.timestamp,
          category: notification.category,
          iconEmoji: notification.iconEmoji,
          isRead: true,
          type: notification.type,
        );
      }).toList();
    });
    // Optimistically update provider count to 0
    Provider.of<NotificationProvider>(context, listen: false).setUnreadCount(0);
  }

  /// Delete notification
  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }
}
