import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/home_views/live_mathches/live_matches_screen.dart';

/// Reusable section header with title and "See all" link
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 8.w,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                title,
                style: FontManager.heading4(color: AppColors.textPrimary),
              ),
            ],
          ),
          if (onSeeAllTap != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LiveMatchesScreen()),
                );
              },
              child: Row(
                spacing: 4.w,
                children: [
                  Text(
                    'See all',
                    style: FontManager.bodySmall(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 14.sp,
                    color: AppColors.primaryColor,
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
