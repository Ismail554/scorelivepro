import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/views/auth/login_screen.dart';

class CongratulationScreen extends StatelessWidget {
  const CongratulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: BackButton(color: Colors.white),
            )),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              Colors.white,
            ],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Success Icon
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9D6B), // Lighter orange backing
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(20.w),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 48.sp,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                // Title
                Text(
                  AppLocalizations.of(context).congratulations,
                  style: FontManager.heading2(fontSize: 24),
                ),
                SizedBox(height: 12.h),
                Text(
                  AppLocalizations.of(context).yourAccountCreated,
                  textAlign: TextAlign.center,
                  style: FontManager.bodySmall(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const Spacer(flex: 3),

                // Go to Login Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false, // Remove all previous routes
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context).goToLogin,
                        style: FontManager.labelLarge(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
