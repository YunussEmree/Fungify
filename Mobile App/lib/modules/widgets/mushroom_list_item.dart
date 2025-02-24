import 'package:flutter/material.dart';
import 'package:fungify/shared/constants/app_colors.dart';
import 'package:fungify/shared/constants/app_text_styles.dart';
import 'package:fungify/shared/constants/app_colors.dart';


class MushroomListItem extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const MushroomListItem({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: AppColors.accentWithOpacity,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          name,
          style: AppTextStyles.body.copyWith(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.highlight,
          size: 20,
        ),
      ),
    );
  }
} 