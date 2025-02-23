import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';

class AppTextStyles {
  static final TextStyle title = GoogleFonts.spaceMono(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 1,
  );

  static final TextStyle titleAccent = GoogleFonts.spaceMono(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
    letterSpacing: 1,
  );

  static final TextStyle body = GoogleFonts.poppins(
    color: AppColors.whiteWithOpacity,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.3,
  );

  static final TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
} 