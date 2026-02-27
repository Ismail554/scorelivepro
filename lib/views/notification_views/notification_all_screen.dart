import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/notification_provider.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/notifications/widget_notification_card.dart';

class NotificationAllScreen extends StatefulWidget {
  const NotificationAllScreen({super.key});

  @override
  State<NotificationAllScreen> createState() => _NotificationAllScreenState();
}

class _NotificationAllScreenState extends State<NotificationAllScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<NotificationProvider>(context, listen: false)
            .markAllAsRead();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              _buildHeader(),

              // Notifications List
              Expanded(
                child: Consumer<NotificationProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoadingNotifications) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final notifications = provider.notifications;

                    return notifications.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return NotificationCard(
                                notification: notification,
                                onDelete: () => provider
                                    .deleteNotification(notification.id),
                                onTap: () =>
                                    provider.markAsRead(notification.id),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
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
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false)
                  .markAllAsRead();
              Navigator.pop(context);
            },
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
                  AppLocalizations.of(context).notifications,
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
                          AppLocalizations.of(context)
                              .unreadNotifications(provider.unreadCount),
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
          InkWell(
            onTap: () =>
                Provider.of<NotificationProvider>(context, listen: false)
                    .markAllAsRead(),
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
                    AppLocalizations.of(context).markAllRead,
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
            AppLocalizations.of(context).noNotifications,
            style: FontManager.bodyLarge(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
