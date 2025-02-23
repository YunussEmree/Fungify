import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Fungi',
          style: GoogleFonts.spaceMono(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            letterSpacing: 1,
          ),
        ),
        Text(
          'App',
          style: GoogleFonts.spaceMono(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.eco_rounded,
          color: AppColors.highlight,
          size: 32,
        ),
      ],
    );
  }
} 