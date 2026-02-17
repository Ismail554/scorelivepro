import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/provider/auth_provider.dart';
import 'package:scorelivepro/views/auth/sign_up/congratulation_screen.dart';
import 'dart:async';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  const OtpVerifyScreen({super.key, this.email = "you@company.com"});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _pinController = TextEditingController();
  Timer? _timer;
  int _start = 60;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 60;
    _isResendEnabled = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_start == 0) {
          setState(() {
            _isResendEnabled = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = AppColors.primaryColor;
    const fillColor = Colors.white;
    const borderColor = Color(0xFFE8E8E8);

    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.w,
      textStyle: FontManager.heading3(
        fontSize: 20,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // Header Icon
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A28),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding: EdgeInsets.all(20.w),
                    child: Image.asset(
                      IconAssets.trophy,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Title
                  Text(
                    "Check Your Email",
                    style: FontManager.heading2(fontSize: 22),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "We've sent a 6-digit OTP to ${widget.email}\nEnter the code below to continue.",
                    textAlign: TextAlign.center,
                    style: FontManager.bodySmall(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ).copyWith(height: 1.5),
                  ),
                  SizedBox(height: 48.h),

                  // Enter OTP Label
                  Text(
                    "Enter OTP Code",
                    style: FontManager.labelMedium(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Pinput
                  Pinput(
                    controller: _pinController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyDecorationWith(
                      border: Border.all(color: focusedBorderColor),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) => print(pin),
                  ),
                  SizedBox(height: 12.h),

                  // Expiry text
                  Text(
                    "This code will expire in 2 minutes",
                    style: FontManager.bodySmall(
                      color: AppColors.textHint,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Verify Button
                  Consumer<AuthProvider>(builder: (context, auth, _) {
                    return SizedBox(
                      width: double.maxFinite,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                if (_pinController.text.length != 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please enter a valid 6-digit code")),
                                  );
                                  return;
                                }

                                final success = await auth.verifyEmail(
                                  widget.email,
                                  _pinController.text,
                                );

                                if (success && context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CongratulationScreen(),
                                    ),
                                  );
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Verification failed. Invalid code.")),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: auth.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Verify OTP",
                                style: FontManager.labelLarge(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    );
                  }),
                  SizedBox(height: 32.h),

                  // Resend Section
                  Text(
                    "Didn't receive the code?",
                    style: FontManager.bodyMedium(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _isResendEnabled
                        ? "You can now resend the code"
                        : "Resend code in ${_start}s",
                    style: FontManager.bodySmall(
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Consumer<AuthProvider>(builder: (context, auth, _) {
                    return TextButton(
                      onPressed: (_isResendEnabled && !auth.isLoading)
                          ? () async {
                              final success =
                                  await auth.resendOtp(widget.email);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(success
                                          ? "OTP resent successfully"
                                          : "Failed to resend OTP. Please try again.")),
                                );
                                if (success) {
                                  setState(() {
                                    startTimer();
                                  });
                                }
                              }
                            }
                          : null,
                      child: Text(
                        "Resend OTP",
                        style: FontManager.labelMedium(
                          color: _isResendEnabled
                              ? const Color(0xFFFF7A28)
                              : AppColors.textHint,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
