import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class MatchCardShimmer extends StatelessWidget {
  const MatchCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // League name shim
            Container(
              width: 100.w,
              height: 12.h,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            // Home Team shim
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150.w,
                  height: 16.h,
                  color: Colors.white,
                ),
                Container(
                  width: 20.w,
                  height: 16.h,
                  color: Colors.white,
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
                  color: Colors.white,
                ),
                Container(
                  width: 20.w,
                  height: 16.h,
                  color: Colors.white,
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
                  color: Colors.white,
                ),
                Container(
                  width: 40.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
