import 'package:flutter/material.dart';

class NotificationBell extends StatelessWidget {
  final bool hasNotification;
  final VoidCallback onTap;

  const NotificationBell({
    super.key,
    required this.hasNotification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: (){
        
      },
      child: Stack(
        children: [
          Icon(
            hasNotification ? Icons.notifications : Icons.notifications_none,
            size: 26,
            color: Colors.white,
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
