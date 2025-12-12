import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/app_strings.dart';
import 'package:scorelivepro/widget/onboarding/onboarding_base_widget.dart';

class OnboadingScreen2 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboadingScreen2({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingBaseWidget(
      backgroundImage: ImageAssets.onboadiing2,
      icon: Icon(
        Icons.notifications_active,
        size: 60.sp,
        color: const Color(0xFFFDC300),
      ),
      title: AppStrings.onboardingTitle2, 
      description: AppStrings
          .onboardingDescription2, 
      buttonText: AppStrings.next, 
      isLastScreen: false,
      onNext: onNext,
      onSkip: onSkip,
      currentPage: 1,
      totalPages: 3,
    );
  }
}
