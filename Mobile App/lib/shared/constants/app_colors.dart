import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2A0E5F);
  static const Color secondary = Color(0xFF3D1B7A);
  static const Color accent = Color(0xFF8B6BFF);
  static const Color highlight = Color(0xFFFF6BE6);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;

  static final Color primaryWithOpacity = secondary.withAlpha(153);
  static final Color secondaryWithOpacity = primary.withAlpha(77);
  static final Color accentWithOpacity = accent.withAlpha(77);
  static final Color highlightWithOpacity = highlight.withAlpha(77);
  static final Color blackWithOpacity = black.withAlpha(77);
  static final Color whiteWithOpacity = white.withAlpha(230);
} 
