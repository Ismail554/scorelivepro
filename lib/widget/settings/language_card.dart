import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Unified Language Card Widget
/// Displays flag, English name, native name, and selection indicator
class LanguageCard extends StatelessWidget {
  final String englishName;
  final String nativeName;
  final String flagEmoji;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCard({
    super.key,
    required this.englishName,
    required this.nativeName,
    required this.flagEmoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppPadding.c12,
      child: Container(
        width: double.infinity,
        padding: AppPadding.r16,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppPadding.c12,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.textPrimary.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Flag Icon
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                borderRadius: AppPadding.c8,
                border: Border.all(
                  color: AppColors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  flagEmoji,
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Language Names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // English Name (large)
                  Text(
                    englishName,
                    style: FontManager.bodyMedium(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ).copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.h),
                  // Native Name (small, grey)
                  Text(
                    nativeName,
                    style: FontManager.bodySmall(
                      fontSize: 14,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // Selection Indicator (Checkmark)
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}
