import 'package:flutter/material.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/views/notification_views/notification_all_screen.dart';

import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/notification_provider.dart';

class NotificationBell extends StatefulWidget {
  final bool
      hasNotification; // Kept for backward compatibility, but provider preferred
  final VoidCallback? onTap;
  final Color? iconColor;

  const NotificationBell({
    super.key,
    required this.hasNotification,
    this.onTap,
    this.iconColor,
  });

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  @override
  void initState() {
    super.initState();
    // Fetch count when bell is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .fetchUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: widget.onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationAllScreen()),
            ).then((_) {
              // Refresh count when returning from notification screen
              Provider.of<NotificationProvider>(context, listen: false)
                  .fetchUnreadCount();
            });
          },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.notifications,
            size: 26,
            color: widget.iconColor ?? Colors.white,
          ),

          /// 🔴 Badge with Count
          Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              final count = provider.unreadCount;
              if (count <= 0) return const SizedBox.shrink();

              return Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Center(
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
