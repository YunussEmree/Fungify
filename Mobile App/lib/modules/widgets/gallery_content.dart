import 'package:flutter/material.dart';
import 'package:fungi_app/modules/widgets/circular_gradient_icon.dart';
import 'package:fungi_app/modules/widgets/gradient_button.dart';
import 'package:fungi_app/shared/constants/app_text_styles.dart';
import 'package:fungi_app/shared/constants/strings.dart';

class GalleryContent extends StatelessWidget {
  final VoidCallback onSelectPhoto;

  const GalleryContent({
    super.key,
    required this.onSelectPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularGradientIcon(icon: Icons.photo_library_rounded),
        const SizedBox(height: 20),
        Text(
          AppStrings.selectPhotoInstruction,
          style: AppTextStyles.body.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 30),
        GradientButton(
          text: AppStrings.selectPhoto,
          onPressed: onSelectPhoto,
        ),
      ],
    );
  }
} 