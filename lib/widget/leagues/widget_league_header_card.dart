import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/widget/mini_widget/mw_notification_bell.dart';

/// Reusable League Header Card Widget
/// Displays league information with stadium background, flag, league name, and season
class LeagueHeaderCard extends StatelessWidget {
  final String leagueName;
  final String country;
  final String season;
  final String? flagEmoji;
  final String? logoUrl;
  final String? backgroundImagePath;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  final bool hasNotification;

  const LeagueHeaderCard({
    super.key,
    required this.leagueName,
    required this.country,
    required this.season,
    this.flagEmoji,
    this.logoUrl,
    this.backgroundImagePath,
    this.onBackPressed,
    this.onNotificationPressed,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270.h,
      width: double.maxFinite,
      child: Stack(
        children: [
          // Stadium Background Image
          Positioned.fill(
            child: Image.asset(
              backgroundImagePath ?? ImageAssets.home_bg,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.darkGrey);
              },
            ),
          ),

          // Dark Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),

          // Header (Back Button, Notification Bell)
          Positioned(
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
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                      ),
                      onPressed: onBackPressed ?? () => Navigator.pop(context),
                    ),

                    // Notification Bell
                    NotificationBell(
                      hasNotification: hasNotification,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // League Information (Flag, Name, Season)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 60.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flag Emoji or Icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Center(
                      child: logoUrl != null
                          ? Image.network(
                              logoUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  flagEmoji != null
                                      ? Text(
                                          flagEmoji!,
                                          style: TextStyle(fontSize: 40.sp),
                                        )
                                      : Icon(
                                          Icons.flag,
                                          color: AppColors.white,
                                          size: 40.sp,
                                        ),
                            )
                          : flagEmoji != null
                              ? Text(
                                  flagEmoji!,
                                  style: TextStyle(fontSize: 40.sp),
                                )
                              : Icon(
                                  Icons.flag,
                                  color: AppColors.white,
                                  size: 40.sp,
                                ),
                    ),
                  ),

                  AppSpacing.h16,

                  // League Name
                  Text(
                    leagueName,
                    style: FontManager.heading1(
                      fontSize: 28,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  AppSpacing.h4,

                  // Country and Season
                  Text(
                    "$country • $season",
                    style: FontManager.bodyMedium(
                      fontSize: 14,
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
