import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/provider/connectivity_provider.dart';

/// A slim, animated banner that appears when there is no internet.
/// Wrap your screen body with this widget — it handles show/hide automatically.
class NoInternetBanner extends StatelessWidget {
  final Widget child;
  const NoInternetBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, _) {
        return Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: connectivity.isConnected
                  ? const SizedBox.shrink()
                  : _banner(context, connectivity),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }

  Widget _banner(BuildContext context, ConnectivityProvider connectivity) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(
            color: AppColors.error.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: AppColors.error,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context).noInternetConnection,
                    style: FontManager.labelMedium(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    AppLocalizations.of(context).checkYourConnection,
                    style: FontManager.bodySmall(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () => connectivity.retry(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  AppLocalizations.of(context).tryAgain,
                  style: FontManager.labelMedium(
                    color: AppColors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
