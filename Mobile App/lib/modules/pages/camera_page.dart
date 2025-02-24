import 'package:flutter/material.dart';
import 'package:fungify/modules/widgets/gradient_container.dart';
import 'package:fungify/shared/constants/app_colors.dart';
import 'package:fungify/shared/constants/app_text_styles.dart';
import 'package:fungify/shared/constants/strings.dart';
import 'package:fungify/modules/widgets/custom_app_bar.dart';
import 'package:fungify/modules/widgets/circular_gradient_icon.dart';
import 'package:fungify/modules/widgets/gradient_button.dart';
import 'package:fungify/modules/main_controller.dart';
import 'package:get/get.dart';

class CameraPage extends StatelessWidget {
  final _mainController = Get.find<MainController>();

  CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: const CustomAppBar(title: AppStrings.takePhoto),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularGradientIcon(icon: Icons.camera_alt_rounded),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.takePhotoInstruction,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 18,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    text: AppStrings.takePhoto,
                    onPressed: _mainController.takePhoto,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
