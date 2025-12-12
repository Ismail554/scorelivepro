import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class FontManager {
  // Font Families
  static const String poppins = "Poppins";
  static const String inter = "Inter";

  // Font Weights
  static const FontWeight w400 = FontWeight.w400;
  static const FontWeight w600 = FontWeight.w600;
  static const FontWeight w700 = FontWeight.w700;
  static const FontWeight w800 = FontWeight.w800;

  // Default Text Colors
  static const Color mainTextColor = AppColors.black;
  static final Color subtitleColor = AppColors.grey4B;
  static const Color subSubtitleColor = AppColors.grey;

  // ================== Text Styles ==================

  // Title Text
  static TextStyle titleText({
    Color color = mainTextColor,
    double fontSize = 22,
  }) => GoogleFonts.roboto(
    fontSize: fontSize.sp,
    fontWeight: w800,
    color: color,
    letterSpacing: 0.0,
  );
  // Big Title Text
  static TextStyle bigTitleText({Color color = Colors.white}) =>
      GoogleFonts.roboto(
        fontSize: 36.sp,
        fontWeight: w800,
        color: color,
        letterSpacing: 0.0,
      );

  //general text
  static TextStyle generalText({
    double fontSize = 18,
    Color color = AppColors.hintTextColor,
  }) => GoogleFonts.roboto(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.0,
    letterSpacing: 0.0,
  );

  // Hint Text
  static TextStyle HintText({
    double fontSize = 16,
    Color color = AppColors.hintTextColor,
  }) => GoogleFonts.roboto(
    fontSize: fontSize.sp,
    fontWeight: w400,
    color: color,
    height: 1.0,
    letterSpacing: 0.sp,
  );

  // Subtitle Text
  static TextStyle subtitleText({
    double fontSize = 16,
    Color color = Colors.grey,
    double height = 1,
  }) => GoogleFonts.montserrat(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
    letterSpacing: 0.0,
  );

  // Subtitle Text
  static TextStyle subSubtitleText({
    double fontSize = 14,
    Color color = Colors.grey,
    double height = 1,
  }) => GoogleFonts.montserrat(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
    letterSpacing: 0.0,
  );

  // button Text
  static TextStyle buttonText({
    double fontSize = 16,
    Color color = Colors.white,
    double height = 1,
  }) => GoogleFonts.roboto(
    fontSize: fontSize.sp,
    fontWeight: FontWeight.w700,
    color: color,
    height: height,
    letterSpacing: 0.0,
  );
}
