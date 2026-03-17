import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/font_manager.dart';

/// Custom snackbar for favorite actions
class FavoriteSnackbar {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  static void show(BuildContext context, String teamName) {
    // Remove existing snackbar if any
    hide();

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _FavoriteSnackbarWidget(
        teamName: teamName,
        onDismiss: hide,
      ),
    );

    overlay.insert(_overlayEntry!);

    // Auto dismiss after 3 seconds
    _timer = Timer(const Duration(seconds: 3), () {
      hide();
    });
  }

  static void hide() {
    _timer?.cancel();
    _timer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _FavoriteSnackbarWidget extends StatelessWidget {
  final String teamName;
  final VoidCallback onDismiss;

  const _FavoriteSnackbarWidget({
    required this.teamName,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16.h,
      left: 16.w,
      right: 16.w,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Red Circle Icon with Orange Glow
              Stack(
                alignment: Alignment.center,
                children: [
                  // Orange glow/halo
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Red circle
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              SizedBox(width: 12.w),

              // Message Text
              Expanded(
                child: Text(
                  "$teamName added to favorites!",
                  style: FontManager.bodyMedium(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              // Close Button
              GestureDetector(
                onTap: onDismiss,
                child: Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
