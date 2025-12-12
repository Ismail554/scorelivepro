import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/widget/onboarding/onboarding_base_widget.dart';

class OnboadingScreen1 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboadingScreen1({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingBaseWidget(
      backgroundImage: ImageAssets.onboadiing1,
      icon: Icon(
        Icons.bolt,
        size: 60.sp,
        color: const Color(0xFFFF7931), // Orange color matching Figma
      ),
      title: AppStrings.onboardingTitle1, // "Live Scores"
      description: AppStrings
          .onboardingDescription1, // "Get live scores and updates from your favorite sports"
      buttonText: AppStrings.next, // "Next"
      isLastScreen: false,
      onNext: onNext,
      onSkip: onSkip,
      currentPage: 0,
      totalPages: 3,
    );
  }
}
