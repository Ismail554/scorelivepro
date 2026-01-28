import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/widget/onboarding/onboarding_controller.dart';
import 'package:scorelivepro/views/main_navigation/main_navigation_screen.dart';
import 'package:scorelivepro/config/storage/secure_storage_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() {
    Timer(const Duration(seconds: 2), () async {
      if (mounted) {
        bool hasUuid = await SecureStorageHelper.hasUuid();
        if (mounted) {
          if (hasUuid) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainNavigationScreen(),
              ),
            );
          } else {
            OnboardingController.navigateToOnboarding(context);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Image.asset(
          ImageAssets.splash,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if image doesn't exist
            return Container(
              color: const Color(0xFFFF7931), // Primary color as fallback
              child: const Center(
                child: Text(
                  'Score Live Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
