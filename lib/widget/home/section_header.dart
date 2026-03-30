import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/widget/mini_widget/mw_blinking_dot.dart';

/// Reusable section header with title and "See all" link
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onSeeAllTap;
  final bool shouldBlink;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onSeeAllTap,
    this.shouldBlink = false,
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
              shouldBlink
                  ? BlinkingDot(
                      color: AppColors.warning,
                      size: 8,
                    )
                  : Container(
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
              onTap: onSeeAllTap,
              child: Row(
                spacing: 4.w,
                children: [
                  Text(
                    actionText ?? AppLocalizations.of(context).seeAll,
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
