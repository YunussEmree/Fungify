import 'package:flutter/material.dart';
import 'package:fungify/modules/widgets/custom_icon_button.dart';
import 'package:fungify/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:fungify/shared/constants/app_colors.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
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
          CustomIconButton(
            icon: Icons.photo_library_rounded,
            onPressed: () => Get.toNamed(Routes.gallerypage),
          ),
          CustomIconButton(
            icon: Icons.camera_alt_outlined,
            onPressed: () => Get.toNamed(Routes.camerapage),
          ),
          CustomIconButton(
            icon: Icons.search_outlined,
            onPressed: () => Get.toNamed(Routes.searchpage),
          ),
        ],
      ),
    );
  }
} 