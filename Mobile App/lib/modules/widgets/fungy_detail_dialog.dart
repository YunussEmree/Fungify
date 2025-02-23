import 'package:flutter/material.dart';
import 'package:fungi_app/models/fungy.dart';
import 'package:fungi_app/modules/widgets/gradient_container.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';
import 'package:fungi_app/shared/constants/app_text_styles.dart';
import 'package:get/get.dart';

class FungyDetailDialog extends StatelessWidget {
  final Fungy fungy;
  final bool showProbability;

  const FungyDetailDialog({
    super.key,
    required this.fungy,
    this.showProbability = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fungy.fungyImageUrl.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      fungy.fungyImageUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        width: 200,
                        color: AppColors.grey.withAlpha(77),
                        child: const Icon(
                          Icons.error_outline,
                          color: AppColors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              _buildDetailRow('İsim:', fungy.name),
              _buildDetailRow('Zehirli:', fungy.venomous ? 'Evet' : 'Hayır'),
              if (showProbability)
                _buildDetailRow('Doğruluk:', '${fungy.probability.toStringAsFixed(2)}%'),
              _buildDetailRow('Açıklama:', fungy.fungyDescription),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text(
                    'Kapat',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.highlight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.button.copyWith(
              color: AppColors.highlight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.body.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
} 