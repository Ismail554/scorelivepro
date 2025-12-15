import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Quick action card widget for home screen
class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: AppPadding.r20,
          decoration: BoxDecoration(
            color: AppColors.cardBG,
            borderRadius: AppPadding.c12,
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32.sp,
                color: iconColor,
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: FontManager.bodyMedium(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
