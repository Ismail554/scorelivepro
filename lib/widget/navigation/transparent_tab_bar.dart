import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Transparent Tab Bar for Match Details
/// Matches Figma design with transparent background
class TransparentTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> tabs;

  const TransparentTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Size get preferredSize => Size.fromHeight(50.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Colors.transparent,
      child: TabBar(
        controller: tabController,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.white.withValues(alpha: 0.6),
        indicatorColor: AppColors.white,
        indicatorWeight: 2,
        labelStyle: FontManager.labelMedium(
          fontSize: 14,
          color: AppColors.white,
        ),
        unselectedLabelStyle: FontManager.labelMedium(
          fontSize: 12,
          color: AppColors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
