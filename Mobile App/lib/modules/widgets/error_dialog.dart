import 'package:flutter/material.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';
import 'package:fungi_app/shared/constants/app_text_styles.dart';
import 'package:get/get.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: AppColors.accent.withAlpha(77),
        ),
      ),
      title: Text(
        'Hata',
        style: AppTextStyles.button.copyWith(color: AppColors.white),
      ),
      content: Text(
        message,
        style: AppTextStyles.body,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Tamam',
            style: AppTextStyles.button.copyWith(color: AppColors.highlight),
          ),
        ),
      ],
    );
  }
} 