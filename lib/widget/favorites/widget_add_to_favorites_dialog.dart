import 'dart:ui'; // BackdropFilter er jonno eta lagbe
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';

class AddToFavoritesDialog extends StatelessWidget {
  final String teamName;
  final String leagueName;
  final VoidCallback? onSave;
  final VoidCallback? onMaybeLater;

  const AddToFavoritesDialog({
    super.key,
    required this.teamName,
    required this.leagueName,
    this.onSave,
    this.onMaybeLater,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Dialog background transparent korechi jate amra nijera design korte pari
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          // 2. Glass Effect: Background ta ektu blur hobe
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              // 3. Transparent BG with slight dark tint (Glass feel)
              color: AppColors.primaryColor
                  .withAlpha(40), // Dark Glass Style matching image
              borderRadius: BorderRadius.circular(20.r),
              // 4. The Request: Border with Primary Color
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1.w,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add to Favorites?",
                      style: FontManager.heading3(
                        color: AppColors
                            .white, // Text White korechi dark bg er jonno
                        fontSize: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        color: AppColors.white.withOpacity(0.7),
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Team Info Card (Updating to blend with glass)
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight
                        .withOpacity(0.1), // Semi-transparent card
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.sports_soccer,
                          color: AppColors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teamName,
                              style: FontManager.teamName(
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              leagueName,
                              style: FontManager.leagueName(
                                color: AppColors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Features List
                _buildFeatureOption(
                  icon: Icons.flash_on_rounded,
                  title: "Quick Access",
                  description: "View all matches instantly",
                ),
                SizedBox(height: 16.h),
                _buildFeatureOption(
                  iconColor: AppColors.yellow,
                  icon: Icons.notifications_active,
                  title: "Live Updates",
                  description: "Goals, red cards & more",
                ),
                SizedBox(height: 16.h),
                _buildFeatureOption(
                  iconColor: Colors.green,
                  icon: Icons.check_circle_outline_rounded,
                  title: "Personalized Feed",
                  description: "Tailored news for you",
                  isSelected: true,
                ),

                SizedBox(height: 24.h),

                // Action Buttons
                Column(
                  spacing: 12.h,
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(AppStrings.saveToFavorites,
                            style: FontManager.buttonText()),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size.fromWidth(double.maxFinite))),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onMaybeLater != null) {
                            onMaybeLater!();
                          }
                        },
                        child: Text(AppStrings.maybeLater,
                            style:
                                FontManager.buttonText(color: AppColors.black)),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size.fromWidth(double.maxFinite),
                            backgroundColor: AppColors.white)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureOption({
    required IconData icon,
    required String title,
    Color iconColor = AppColors.primaryLight,
    required String description,
    bool isSelected = false,
  }) {
    // Feature row gulo keo dark theme er sathe adjust korlam
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontManager.labelMedium(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: FontManager.bodySmall(
                      color: AppColors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
