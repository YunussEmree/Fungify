import 'package:flutter/material.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';

class CircularGradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const CircularGradientIcon({
    super.key,
    required this.icon,
    this.size = 80,
    this.color = AppColors.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
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
      ),
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
} 