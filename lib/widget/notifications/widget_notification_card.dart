import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/notification_views/models/notification_model.dart';

/// Notification Card Widget
class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey.shade200
                : AppColors.primaryColor,
            width: notification.isRead ? 1.w : 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Notification Icon (Circular with Emoji)
            // Container(
            //   width: 48.w,
            //   height: 48.w,
            //   decoration: BoxDecoration(
            //     color: _getIconBackgroundColor(),
            //     shape: BoxShape.circle,
            //   ),
            //   child: Center(
            //     child: Text(
            //       notification.iconEmoji,
            //       style: TextStyle(fontSize: 24.sp),
            //     ),
            //   ),
            // ),

            SizedBox(width: 12.w),

            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notification.title,
                    style: FontManager.heading4(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Content
                  Text(
                    notification.content,
                    style: FontManager.bodyMedium(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8.h),

                  // Timestamp and Category
                  Row(
                    children: [
                      Text(
                        notification.timestamp,
                        style: FontManager.bodySmall(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        " • ${notification.category}",
                        style: FontManager.bodySmall(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Delete Icon
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.delete_outline,
                  size: 20.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get icon background color based on notification type
  Color _getIconBackgroundColor() {
    switch (notification.type) {
      case NotificationType.transfer:
        return AppColors.primaryColor.withOpacity(0.1);
      case NotificationType.news:
        return AppColors.info.withOpacity(0.1);
      case NotificationType.injury:
        return AppColors.error.withOpacity(0.1);
      case NotificationType.match:
        return AppColors.success.withOpacity(0.1);
      case NotificationType.league:
        return AppColors.warning.withOpacity(0.1);
      case NotificationType.team:
        return AppColors.primaryColor.withOpacity(0.1);
    }
  }
}
