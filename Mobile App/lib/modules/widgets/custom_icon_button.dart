import 'package:flutter/material.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ 
            AppColors.highlightWithOpacity,
            AppColors.accentWithOpacity,
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