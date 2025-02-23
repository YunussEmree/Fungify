import 'package:flutter/material.dart';
import 'package:fungi_app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildHeader(),
            const SizedBox(height: 20),
            _buildMainContent(),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Fungi',
          style: GoogleFonts.spaceMono(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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

  Widget _buildMainContent() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondaryWithOpacity,
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
            'Click the camera icon to start\nclassifying with camera.',
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

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondaryWithOpacity,
            AppColors.primaryWithOpacity,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity,
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavigationButton(
            Icons.photo_library_rounded,
            () => Get.toNamed(Routes.GALLERYPAGE),
          ),
          _buildNavigationButton(
            Icons.camera_alt_outlined,
            () => Get.toNamed(Routes.CAMERAPAGE),
          ),
          _buildNavigationButton(
            Icons.search_outlined,
            () => Get.toNamed(Routes.SEARCHPAGE),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentWithOpacity,
            AppColors.highlightWithOpacity,
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accentWithOpacity,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackWithOpacity,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          splashColor: AppColors.accentWithOpacity,
          highlightColor: AppColors.highlightWithOpacity,
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Icon(
              icon,
              color: AppColors.whiteWithOpacity,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
} 