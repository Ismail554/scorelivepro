import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Tomar project er AppColors import koro
// import 'package:scorelivepro/core/app_colors.dart';

class WidgetMatchInformation extends StatelessWidget {
  // 1. Eigulo holo "Input Slot" ba Variables
  final String title;
  final String stadium;
  final String referee;
  final String attendance;

  const WidgetMatchInformation({
    super.key,
    this.title = "Match Information", // Default title set kore dilam
    required this.stadium,
    required this.referee,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.shade300, // Light grey border
          width: 1,
        ),
        boxShadow: [
          // Ektu shadow dilam jate sundor bhashe
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Title Part ---
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          
          // --- Data Rows (Input theke asha data boshiye dilam) ---
          _buildInfoRow("Stadium:", stadium),
          SizedBox(height: 12.h),
          
          _buildInfoRow("Referee:", referee),
          SizedBox(height: 12.h),
          
          _buildInfoRow("Attendance:", attendance),
        ],
      ),
    );
  }

  // --- Helper Widget (Internal Use Only) ---
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade500, // Label color light
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87, // Value color dark
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}