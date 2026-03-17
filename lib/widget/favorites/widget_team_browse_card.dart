import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Team browse card widget for Browse Teams screen
class TeamBrowseCard extends StatelessWidget {
  final String teamName;
  final String leagueName;
  final bool isFavorited;

  final VoidCallback? onFavoriteToggle;
  final String? logoUrl;

  const TeamBrowseCard({
    super.key,
    required this.teamName,
    required this.leagueName,
    this.isFavorited = false,
    this.onFavoriteToggle,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.greyE8,
          width: 1.w,
        ),
        // Removed heavy shadow to match the cleaner look in the image (or kept very subtle)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Team Logo (circular)
          Container(
            width: 48.w,
            height: 48.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors
                  .white, // Changed to white/transparent as per typical clean designs
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greyE8, width: 0.5),
            ),
            child: logoUrl != null
                ? Image.network(
                    logoUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      IconAssets.soccer_icon,
                      fit: BoxFit.contain,
                    ),
                  )
                : Image.asset(
                    IconAssets.soccer_icon,
                    fit: BoxFit.contain,
                  ),
          ),

          SizedBox(width: 16.w),

          // Team Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  style: FontManager.teamName(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                if (leagueName.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    leagueName,
                    style: FontManager.leagueName(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Favorite/Add Button
          if (onFavoriteToggle != null)
            GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  // Orange if favorited, Light Grey/White if not
                  color: isFavorited
                      ? const Color(
                          0xFFFF6B2C) // Example orange color from the image description
                      : const Color(0xFFF3F4F6), // Light grey
                  borderRadius: BorderRadius.circular(
                      12.r), // Rounded corners like in the image
                ),
                child: Icon(
                  isFavorited ? Icons.favorite : Icons.add,
                  color: isFavorited ? Colors.white : const Color(0xFF5A5A5A),
                  size: 20.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
