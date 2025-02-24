import 'package:flutter/material.dart';
import 'package:fungify/shared/constants/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.highlight,
      ),
    );
  }
} 