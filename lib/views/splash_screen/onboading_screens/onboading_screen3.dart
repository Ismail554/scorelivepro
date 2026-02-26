import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/widget/onboarding/onboarding_base_widget.dart';

class OnboadingScreen3 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboadingScreen3({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingBaseWidget(
      backgroundImage: ImageAssets.onboadiing3,
      icon: Icon(
        Icons.favorite,
        size: 60.sp,
        color: const Color(0xFFFF7931), // Orange color matching Figma
      ),
      title: AppLocalizations.of(context).onboardingTitle3, // "Stay Connected"
      description: AppLocalizations.of(context)
          .onboardingDescription3, // "Follow teams, leagues, and never miss a moment"
      buttonText: AppLocalizations.of(context).getStarted, // "Get Started"
      isLastScreen: true,
      onNext: onNext,
      onSkip: onSkip,
      currentPage: 2,
      totalPages: 3,
    );
  }
}
