import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fungify/shared/constants/app_colors.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryWithOpacity,
            AppColors.primaryWithOpacity,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity,
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImageContainer(),
          const SizedBox(height: 30),
          _buildInstructionContainer(),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentWithOpacity,
            AppColors.highlightWithOpacity,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentWithOpacity,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/mushroom.png',
          height: 180,
          width: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInstructionContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentWithOpacity,
            AppColors.highlightWithOpacity,
          ],  
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.accentWithOpacity,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.camera_enhance_rounded,
            color: AppColors.highlight, 
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            'Click the camera icon to start classification.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.whiteWithOpacity,
              fontSize: 16,
              height: 1.5,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
} 