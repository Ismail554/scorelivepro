import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Base widget for onboarding screens
/// Provides common layout and styling for all onboarding screens
class OnboardingBaseWidget extends StatelessWidget {
  final String backgroundImage;
  final Widget icon;
  final String title;
  final String description;
  final String buttonText;
  final bool isLastScreen;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int currentPage;
  final int totalPages;

  const OnboardingBaseWidget({
    super.key,
    required this.backgroundImage,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.isLastScreen,
    required this.onNext,
    required this.onSkip,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Dark Overlay
          _buildBackgroundWithOverlay(),

          // Content
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  // Skip Button
                  _buildSkipButton(),

                  AppSpacing.h64,

                  // Icon
                  _buildIcon(),

                  AppSpacing.h32,

                  Container(
                    width: double.maxFinite,
                    height: 140.h,
                    child: Column(
                      children: [
                        // Title
                        _buildTitle(),

                        AppSpacing.h16,

                        // Description
                        _buildDescription(),
                      ],
                    ),
                  ),

                  // AppSpacing.h48,
                  // Pagination Dots
                  _buildPaginationDots(),
                  AppSpacing.h32,

                  // Navigation Button
                  _buildNavigationButton(),

                  AppSpacing.h32,

                  AppSpacing.h40,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Background image with dark overlay
  Widget _buildBackgroundWithOverlay() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.asset(
          backgroundImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(color: AppColors.black);
          },
        ),
        // Dark Overlay with alpha (matching Figma - dark overlay on images)
        Container(
          color:
              AppColors.black.withOpacity(0.8), // Dark overlay to match Figma
        ),
      ],
    );
  }

  /// Skip button in top right
  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.h,
          right: 24.w,
        ),
        child: TextButton(
          onPressed: onSkip,
          child: Text(
            'Skip',
            style: FontManager.bodyMedium(
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Central icon
  Widget _buildIcon() {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.orange.withOpacity(0.3),
        border: Border.all(
          color: Colors.orange,
          width: 2,
        ),
      ),
      child: Center(
        child: icon,
      ),
    );
  }

  /// Title text
  Widget _buildTitle() {
    return Padding(
      padding: AppPadding.h24,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: FontManager.heading1(
          fontSize: 28,
          color: AppColors.white,
        ),
      ),
    );
  }

  /// Description text
  Widget _buildDescription() {
    return Padding(
      padding: AppPadding.h32,
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: FontManager.bodyMedium(
          fontSize: 16,
          color: AppColors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  /// Navigation button (Next or Get Started)
  Widget _buildNavigationButton() {
    return Padding(
      padding: AppPadding.h24,
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppPadding.c12,
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: FontManager.buttonText(
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
              AppSpacing.w8,
              Icon(
                Icons.arrow_forward,
                size: 20.sp,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Pagination dots
  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => _buildDot(index == currentPage),
      ),
    );
  }

  /// Individual pagination dot
  Widget _buildDot(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryColor
            : AppColors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
