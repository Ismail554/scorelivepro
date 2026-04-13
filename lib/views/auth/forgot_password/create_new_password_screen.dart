import 'package:flutter/material.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/widget/custom_snackbar.dart';
import 'package:scorelivepro/views/auth/sign_up/congratulation_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const CreateNewPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const BackButton(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20.h),

                // Header Icon
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
                  AppLocalizations.of(context).createNewPassword,
                  style: FontManager.heading2(fontSize: 22.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalizations.of(context).newPasswordDifferentText,
                  textAlign: TextAlign.center,
                  style: FontManager.bodySmall(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 40.h),

                // Password Field
                _buildLabel(AppLocalizations.of(context).newPassword),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: _inputDecoration(
                    hintText: AppLocalizations.of(context).enterNewPassword,
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
                SizedBox(height: 20.h),

                // Confirm Password Field
                _buildLabel(AppLocalizations.of(context).confirmPassword),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: _inputDecoration(
                    hintText: AppLocalizations.of(context).confirmNewPasswordHint,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textHint,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  style: FontManager.bodyMedium(),
                ),
                SizedBox(height: 32.h),

                // Submit Button
                Consumer<AuthProvider>(builder: (context, auth, _) {
                  return SizedBox(
                    width: double.maxFinite,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              if (_passwordController.text.isEmpty ||
                                  _confirmPasswordController.text.isEmpty) {
                                CustomSnackBar.show(
                                  context: context,
                                  message: AppLocalizations.of(context)
                                      .pleaseFillAllFields,
                                  isError: true,
                                );
                                return;
                              }

                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                CustomSnackBar.show(
                                  context: context,
                                  message: AppLocalizations.of(context)
                                      .passwordsDoNotMatch,
                                  isError: true,
                                );
                                return;
                              }

                              final success = await auth.passwordResetConfirm(
                                widget.email,
                                widget.otp,
                                _passwordController.text,
                                _confirmPasswordController.text,
                              );

                              if (success && context.mounted) {
                                  CustomSnackBar.show(
                                    context: context,
                                    message: AppLocalizations.of(context)
                                        .passwordResetSuccess,
                                    isError: false,
                                  );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CongratulationScreen(
                                      isPasswordReset: true,
                                    ),
                                  ),
                                  (route) => false,
                                );
                                } else if (context.mounted) {
                                  CustomSnackBar.show(
                                    context: context,
                                    message: AppLocalizations.of(context)
                                        .passwordResetFailed,
                                    isError: true,
                                  );
                                }
                            },
                      child: auth.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              AppLocalizations.of(context).resetPassword,
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
}
