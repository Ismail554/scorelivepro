import 'package:flutter/material.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/views/notification_views/notification_all_screen.dart';

class NotificationBell extends StatelessWidget {
  final bool hasNotification;
  final VoidCallback? onTap;
  final Color? iconColor;

  NotificationBell({
    super.key,
    required this.hasNotification,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationAllScreen()),
            );
          },
      child: Stack(
        children: [
          Icon(
            hasNotification ? Icons.notifications : Icons.notifications_none,
            size: 26,
            // Correct way
            color: iconColor ?? Colors.white,
          ),

          /// 🔴 Small dot
          if (hasNotification)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
