import 'package:flutter/material.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';
import 'package:fungi_app/shared/constants/app_text_styles.dart';
import 'package:get/get.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool closeOnPressed;

  const AlertDialogWidget({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'Tamam',
    this.onPressed,
    this.closeOnPressed = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: AppColors.accentWithOpacity,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.button.copyWith(color: AppColors.white),
      ),
      content: Text(
        message,
        style: AppTextStyles.body,
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (closeOnPressed) {
              Get.back();
            }
            onPressed?.call();
          },
          child: Text(
            buttonText,
            style: AppTextStyles.button.copyWith(color: AppColors.highlight),
          ),
        ),
      ],
    );
  }
}
