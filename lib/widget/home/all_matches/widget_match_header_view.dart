import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';

class WidgetMatchHeaderView extends StatelessWidget {
  // 1. Ingredients (Variables)
  final String backgroundImage;
  final String leagueName;
  final String matchStatus; // e.g., "LIVE - 78'"
  final String homeTeamName;
  final String awayTeamName;
  final String score; // e.g., "2 - 2"
  final VoidCallback onNotificationPressed;

  const WidgetMatchHeaderView({
    super.key,
    required this.backgroundImage,
    required this.leagueName,
    required this.matchStatus,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.score,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    // 2. Main Structure (The Billboard Frame)
    return SizedBox(
      height: 220.h,
      width: double.maxFinite,
      child: Stack(
        children: [
          // Background Image Layer
          Positioned.fill(
            child: Image.asset(
              backgroundImage, // Variable
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.darkGrey);
              },
            ),
          ),

          // Dark Overlay Layer (Text jeno clear dekha jay)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),

          // Header Layer (Back Button, League Name)
          _buildHeader(context),

          // Match Overview Layer (Score, Teams)
          _buildMatchOverview(),
        ],
      ),
    );
  }

  /// Helper Methods (Internal parts of the widget)

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: AppPadding.h16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () {
                  Navigator.pop(context, true);
                }, // Using callback
              ),

              // League Name
              Text(
                leagueName, // Variable
                style: FontManager.heading3(
                  fontSize: 18,
                  color: AppColors.white,
                ),
              ),

              // Notification Bell
              NotificationBell(
                hasNotification: true,
                onTap: onNotificationPressed, // Using callback
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 FIXED PART HERE
  Widget _buildMatchOverview() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      // 'top: 60.h' remove kora hoyeche jate overflow na hoy
      child: Padding(
        padding: EdgeInsets.only(bottom: 30.h), // padding adjusted
        child: Column(
          mainAxisSize: MainAxisSize.min, // Content onujayi height nebe
          children: [
            // AppSpacing remove kora hoyeche, spacing er dorkar nai ekhane

            // Teams and Score
            _buildScoreboard(),
          ],
        ),
      ),
    );
  }

  // Note: Ei widget ta use kora hoyni, but future e lagle use korte paro
  Widget _buildLiveIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.w8,
          Text(
            matchStatus, // Variable
            style: FontManager.labelMedium(
              fontSize: 12,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreboard() {
    return Padding(
      padding: AppPadding.h24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home Team
          _buildTeamItem(homeTeamName), // Reused function for team

          // Score
          Expanded(
            child: Column(
              children: [
                Text(
                  score, // Variable
                  style: FontManager.matchScore(
                    fontSize: 34.sp,
                    color: AppColors.white,
                  ),
                ),
                // Jodi match status (Live/Time) dekhate chao, _buildLiveIndicator() ekhane call korte paro
              ],
            ),
          ),

          // Away Team
          _buildTeamItem(awayTeamName), // Reused function for team
        ],
      ),
    );
  }

  // Small helper to avoid repeating code for Home and Away team UI
  Widget _buildTeamItem(String teamName) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 48.w,
              height: 48.w,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.greyE8.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                IconAssets.soccer_icon, // Keeping icon static for now
                fit: BoxFit.contain,
              ),
            ),
          ),
          AppSpacing.h8,
          Text(
            teamName,
            style: FontManager.bodyMedium(
              fontSize: 14,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
