import 'package:flutter/material.dart';
import 'package:scorelivepro/views/main_navigation/main_navigation_screen.dart';
import 'package:scorelivepro/views/splash_screen/onboading_screens/onboading_screen1.dart';
import 'package:scorelivepro/views/splash_screen/onboading_screens/onboading_screen2.dart';
import 'package:scorelivepro/views/splash_screen/onboading_screens/onboading_screen3.dart';

/// Controller for managing onboarding screen navigation
class OnboardingController {
  /// Navigate to onboarding screens
  static void navigateToOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingPageView(),
      ),
    );
  }

  /// Skip onboarding and go to main navigation
  static void skipOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationScreen(),
      ),
    );
  }

  /// Complete onboarding and go to main navigation
  static void completeOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationScreen(),
      ),
    );
  }
}

/// PageView widget for onboarding screens
class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({super.key});

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      OnboardingController.completeOnboarding(context);
    }
  }

  void _skipOnboarding() {
    OnboardingController.skipOnboarding(context);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      children: [
        OnboadingScreen1(
          onNext: _nextPage,
          onSkip: _skipOnboarding,
        ),
        OnboadingScreen2(
          onNext: _nextPage,
          onSkip: _skipOnboarding,
        ),
        OnboadingScreen3(
          onNext: _nextPage,
          onSkip: _skipOnboarding,
        ),
      ],
    );
  }
}
