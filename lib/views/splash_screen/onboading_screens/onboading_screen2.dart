import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
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
      title: AppLocalizations.of(context).onboardingTitle2,
      description: AppLocalizations.of(context).onboardingDescription2,
      buttonText: AppLocalizations.of(context).next,
      isLastScreen: false,
      onNext: onNext,
      onSkip: onSkip,
      currentPage: 1,
      totalPages: 3,
    );
  }
}
