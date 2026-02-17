import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/views/auth/sign_up/otp_verifiy_screen.dart'; // For navigation

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            stops: [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const BackButton(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20.h),

                // Header Icon/Image (Consistent with Login)
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A28), // Orange background
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  padding: EdgeInsets.all(20.w),
                  child: Image.asset(
                    IconAssets.trophy, // Using same asset as login for now
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 24.h),

                // Title
                Text(
                  "Verify Your Email",
                  style: FontManager.heading2(fontSize: 22.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Enter your email address to change password",
                  textAlign: TextAlign.center,
                  style: FontManager.bodySmall(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 40.h),

                // Email Field
                _buildLabel("Email Address"),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration(
                    hintText: "Enter your email",
                    prefixIcon: Icons.email_outlined,
                  ),
                  style: FontManager.bodyMedium(),
                ),
                SizedBox(height: 32.h),

                // Send OTP Button
                Consumer<AuthProvider>(builder: (context, auth, _) {
                  return SizedBox(
                    width: double.maxFinite,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              if (_emailController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please enter your email")),
                                );
                                return;
                              }

                              final success = await auth
                                  .forgotPassword(_emailController.text);

                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("OTP sent successfully")),
                                );
                                NavigateToOtp();
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Failed to send OTP. Please try again.")),
                                );
                              }
                            },
                      child: auth.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Send OTP",
                              style: FontManager.labelLarge(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void NavigateToOtp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerifyScreen(
          email: _emailController.text,
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
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Color(0xFFFF7A28)),
      ),
    );
  }
}
