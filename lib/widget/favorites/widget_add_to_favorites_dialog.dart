import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Add to Favorites dialog widget
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add to Favorites?",
                  style: FontManager.heading3(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: AppColors.textTertiary,
                    size: 24.sp,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Team Info Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.bgTertiary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.greyE8.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.sports_soccer,
                      color: AppColors.textSecondary,
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
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          leagueName,
                          style: FontManager.leagueName(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    color: AppColors.primaryColor,
                    size: 24.sp,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Feature Options
            _buildFeatureOption(
              icon: Icons.favorite,
              title: "Quick Access",
              description: "View all matches instantly from Favorites tab",
            ),

            SizedBox(height: 16.h),

            _buildFeatureOption(
              icon: Icons.notifications,
              title: "Live Updates",
              description: "Get notified about goals, red cards & more",
            ),

            SizedBox(height: 16.h),

            _buildFeatureOption(
              icon: Icons.check_circle,
              title: "Personalized Feed",
              description: "News & highlights tailored for you",
              isSelected: true,
            ),

            SizedBox(height: 24.h),

            // Action Buttons
            Row(
              children: [
                // Save to Favorites Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSave?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Save to Favorites",
                      style: FontManager.labelMedium(
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Maybe Later Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onMaybeLater?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(
                        color: AppColors.greyE8,
                        width: 1.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Maybe Later",
                      style: FontManager.labelMedium(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureOption({
    required IconData icon,
    required String title,
    required String description,
    bool isSelected = false,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.success.withOpacity(0.1)
                : AppColors.greyE8,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColors.success : AppColors.textSecondary,
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
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: FontManager.bodySmall(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.add_circle_outline,
          color: AppColors.textTertiary,
          size: 24.sp,
        ),
      ],
    );
  }
}

