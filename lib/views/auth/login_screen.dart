import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';

import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/views/auth/forgot_password/forgot_password_screen.dart';
import 'package:scorelivepro/views/auth/sign_up/sign_up_screen.dart';
import 'package:scorelivepro/views/auth/sign_up/otp_verifiy_screen.dart';
import 'package:scorelivepro/views/main_navigation/main_navigation_screen.dart';
import 'package:scorelivepro/provider/notification_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              Colors.white,
            ],
            stops: [
              0.0,
              0.4
            ], // Adjust stops to fade out at mid-screen like design
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 14.h),
                // Header Icon/Image
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: const Color(
                        0xFFFF7A28), // Orange background from design
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  padding: EdgeInsets.all(20.w),
                  child: Image.asset(
                    IconAssets.trophy, // Using existing asset
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 24.h),

                // Welcome Text
                Text(
                  AppLocalizations.of(context).welcome_back,
                  style: FontManager.heading2(fontSize: 22.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalizations.of(context).loginToSyncMsg,
                  textAlign: TextAlign.center,
                  style: FontManager.bodySmall(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 32.h),

                // Email Field
                _buildLabel(AppLocalizations.of(context).emailAddress),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration(
                    hintText: AppLocalizations.of(context).enterYourEmail,
                    prefixIcon: Icons.email_outlined,
                  ),
                  style: FontManager.bodyMedium(),
                ),
                SizedBox(height: 8.h),

                // Password Field
                _buildLabel(AppLocalizations.of(context).password),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: _inputDecoration(
                    hintText: AppLocalizations.of(context).enterYourPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textHint,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  style: FontManager.bodyMedium(),
                ),
                SizedBox(height: 16.h),

                //Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppLocalizations.of(context).forgotPassword,
                      style: FontManager.labelMedium(
                        fontSize: 14.sp,
                        color: const Color(0xFFFF7A28),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Login Button
                Consumer<AuthProvider>(builder: (context, auth, _) {
                  return SizedBox(
                    width: double.maxFinite,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(AppLocalizations.of(context)
                                          .emailPasswordEmpty)),
                                );
                                return;
                              }

                              final authResult =
                                  await auth.login(email, password);

                              if (!context.mounted) return;

                              if (authResult == null) {
                                // Success: register device and navigate
                                context
                                    .read<NotificationProvider>()
                                    .registerDevice(true);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(AppLocalizations.of(context)
                                          .loginSuccessful)),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MainNavigationScreen(),
                                  ),
                                );
                              } else if (authResult ==
                                      "UNVERIFIED_ACCOUNT_OTP_SENT" &&
                                  context.mounted) {
                                // Specific flow for unverified users
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtpVerifyScreen(
                                      email: _emailController.text,
                                      isPasswordReset: false,
                                    ),
                                  ),
                                );
                              } else if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(authResult ??
                                          AppLocalizations.of(context).loginFailedEmailPassword)),
                                );
                              }
                            },
                      child: auth.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              AppLocalizations.of(context).login,
                              style: FontManager.labelLarge(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  );
                }),
                SizedBox(height: 18.h),

                // OR Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        AppLocalizations.of(context).or,
                        style: FontManager.bodySmall(),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Social Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 64.w,
                      height: 64.w,
                      child: OutlinedButton(
                        onPressed: signIn,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: Center(
                          child:
                              Image.asset(IconAssets.google_icon, width: 28.w),
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),
                    // Apple Login
                    SizedBox(
                      width: 64.w,
                      height: 64.w,
                      child: OutlinedButton(
                        onPressed: appleSignIn,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: Center(
                          child: Icon(Icons.apple,
                              size: 32.w, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigationScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline,
                          color: AppColors.textPrimary, size: 24.w),
                      SizedBox(width: 8.w),
                      Text(
                        AppLocalizations.of(context).continueAsGuest,
                        style: FontManager.labelMedium(
                          fontSize: 16.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.h10,

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).dontHaveAccount,
                      style: FontManager.bodyMedium(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context).signUp,
                        style: FontManager.labelMedium(
                          color: const Color(0xFFFF7A28),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: FontManager.labelMedium(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: FontManager.bodyMedium(color: AppColors.textHint),
      prefixIcon: Icon(prefixIcon, color: AppColors.textHint),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Color(0xFFFF7A28)),
      ),
    );
  }

  Future signIn() async {
    final success =
        await Provider.of<AuthProvider>(context, listen: false).googleLogin();
    if (success && mounted) {
      // Register device after successful Google login
      context.read<NotificationProvider>().registerDevice(true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  Future appleSignIn() async {
    final success =
        await Provider.of<AuthProvider>(context, listen: false).appleLogin();
    if (success && mounted) {
      // Register device after successful Apple login
      context.read<NotificationProvider>().registerDevice(true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }
}
