import 'package:flutter/material.dart';
import 'package:fungi_app/modules/widgets/gradient_container.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';
import 'package:fungi_app/shared/constants/app_text_styles.dart';
import 'package:fungi_app/shared/constants/strings.dart';
import 'package:fungi_app/modules/widgets/custom_app_bar.dart';
import 'package:fungi_app/modules/widgets/circular_gradient_icon.dart';
import 'package:fungi_app/modules/widgets/gradient_button.dart';
import 'package:fungi_app/modules/main_controller.dart';
import 'package:get/get.dart';

class GalleryPage extends StatelessWidget {
  final _mainController = Get.find<MainController>();

  GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: const CustomAppBar(title: AppStrings.selectFromGallery),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularGradientIcon(icon: Icons.photo_library_rounded),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.selectPhotoInstruction,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 18,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    text: AppStrings.selectPhoto,
                    onPressed: _mainController.selectAndProcessImage,
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
