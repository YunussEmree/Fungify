import 'package:flutter/material.dart';
import 'package:fungify/shared/constants/app_colors.dart';

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
          ],
        ),
      ),
    );
  }
} 