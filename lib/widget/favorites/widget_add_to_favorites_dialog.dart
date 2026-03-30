import 'dart:ui'; // BackdropFilter er jonno eta lagbe
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/team_provider.dart';
import 'package:scorelivepro/services/api_service.dart';
import 'package:scorelivepro/services/league_service.dart';

class AddToFavoritesDialog extends StatelessWidget {
  final int id;
  final String name;
  final String subtitle;
  final Widget? logo;
  final VoidCallback? onSave;
  final VoidCallback? onMaybeLater;
  final bool isLeague;

  const AddToFavoritesDialog({
    super.key,
    required this.id,
    required this.name,
    required this.subtitle,
    this.onSave,
    this.logo,
    this.onMaybeLater,
    this.isLeague = false,
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
            child: SingleChildScrollView(
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
                          color: AppColors.white.withValues(alpha: 0.7),
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Team/League Info Card (Updating to blend with glass)
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight
                          .withValues(alpha: 0.1), // Semi-transparent card
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        Container(
                            width: 48.w,
                            height: 48.w,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: logo),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: FontManager.teamName(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                subtitle,
                                style: FontManager.leagueName(
                                  color: AppColors.white.withValues(alpha: 0.7),
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
                          onPressed: () async {
                            if (isLeague) {
                              // LEAGUE LOGIC
                              debugPrint(
                                  "CALLING API: ${ApiEndPoint.addToFavoriteLeaques()} with ID: $id (POST)");
                              final error =
                                  await LeagueService.addLeagueToFavorites(id);

                              if (context.mounted) {
                                Navigator.of(context).pop();
                                if (error == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.check_circle_outline,
                                              color: Colors.white),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              AppLocalizations.of(context).addedToFavoritesMsg(name),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppColors.success,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.all(16),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.error_outline,
                                              color: Colors.white),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              AppLocalizations.of(context).loginRequiredForFavorites,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.all(16),
                                    ),
                                  );
                                }
                              }
                            } else {
                              // TEAM LOGIC
                              debugPrint(
                                  "CALLING API: ${ApiEndPoint.addToFavoriteTeams()} with ID: $id (POST)");
                              // Note: We are printing the endpoint here for visibility,
                              // but the actual call happens inside TeamProvider which might use a different method.
                              // Ideally, logging should be inside the service/provider, but user asked here too or "print all api calls".
                              await Provider.of<TeamProvider>(context,
                                      listen: false)
                                  .addTeamToFavorites(id, name, context);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }

                            if (onSave != null) onSave!();
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size.fromWidth(double.maxFinite)),
                          child: Text(AppStrings.saveToFavorites,
                              style: FontManager.buttonText())),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (onMaybeLater != null) {
                              onMaybeLater!();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size.fromWidth(double.maxFinite),
                              backgroundColor: AppColors.white),
                          child: Text(AppStrings.maybeLater,
                              style: FontManager.buttonText(
                                  color: AppColors.black))),
                    ],
                  )
                ],
              ),
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
        color: AppColors.white.withValues(alpha: 0.1),
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
                color: iconColor.withValues(alpha: 0.1),
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
                      color: AppColors.white.withValues(alpha: 0.6),
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
