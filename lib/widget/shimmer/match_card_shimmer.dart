import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchCardShimmer extends StatefulWidget {
  const MatchCardShimmer({super.key});

  @override
  State<MatchCardShimmer> createState() => _MatchCardShimmerState();
}

class _MatchCardShimmerState extends State<MatchCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1.w,
            ),
          ),
          child: Opacity(
            opacity: 0.5 + 0.5 * _controller.value, // Simple blink effect
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // League name shim
                Container(
                  width: 100.w,
                  height: 12.h,
                  color: Colors.grey.shade200,
                ),
                SizedBox(height: 16.h),
                // Home Team shim
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150.w,
                      height: 16.h,
                      color: Colors.grey.shade200,
                    ),
                    Container(
                      width: 20.w,
                      height: 16.h,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Away Team shim
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150.w,
                      height: 16.h,
                      color: Colors.grey.shade200,
                    ),
                    Container(
                      width: 20.w,
                      height: 16.h,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Footer shim
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60.w,
                      height: 12.h,
                      color: Colors.grey.shade200,
                    ),
                    Container(
                      width: 40.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
