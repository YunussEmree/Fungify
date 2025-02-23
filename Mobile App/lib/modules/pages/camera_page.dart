import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fungi_app/modules/widgets/gradient_container.dart';
import 'package:fungi_app/modules/main_controller.dart';
import 'package:get/get.dart';
import 'package:fungi_app/models/fungy.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  Future<void> _takePhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null && context.mounted) {
        debugPrint('Captured photo: ${photo.path}');
        final result = await Get.find<MainController>().pickImage(context, imagePath: photo.path);
        if (result != null && context.mounted) {
          _showFungyDetails(context, result);
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (context.mounted) {
        Get.dialog(
          AlertDialog(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: AppColors.accentWithOpacity,
              ),
            ),
            title: Text(
              'Hata',
              style: GoogleFonts.poppins(color: AppColors.white),
            ),
            content: Text(
              'Fotoğraf çekerken bir hata oluştu. Lütfen tekrar deneyin.',
              style: GoogleFonts.poppins(color: AppColors.whiteWithOpacity),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Tamam',
                  style: GoogleFonts.poppins(color: AppColors.highlight),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    }
  }

  void _showFungyDetails(BuildContext context, Fungy fungy) {
    Get.dialog(
      Dialog(
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
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          width: 200,
                          color: AppColors.grey,
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
                _buildDetailRow(context, 'İsim:', fungy.name),
                _buildDetailRow(context, 'Zehirli:', fungy.venomous ? 'Evet' : 'Hayır'),
                _buildDetailRow(context, 'Doğruluk:', '${fungy.probability.toStringAsFixed(2)}%'),
                _buildDetailRow(context, 'Açıklama:', fungy.fungyDescription),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    child: Text(
                      'Kapat',
                      style: GoogleFonts.poppins(
                        color: AppColors.highlight,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.highlight,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: AppColors.whiteWithOpacity,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Take Photo',
        style: GoogleFonts.poppins(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientContainer(
            child: _buildCameraContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCameraIcon(),
        const SizedBox(height: 20),
        _buildInstructionText(),
        const SizedBox(height: 30),
        _buildCameraButton(context),
      ],
    );
  }

  Widget _buildCameraIcon() {
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
      child: const Icon(
        Icons.camera_alt_rounded,
        size: 80,
        color: AppColors.highlight,
      ),
    );
  }

  Widget _buildInstructionText() {
    return Text(
      'Use the camera to take\na mushroom photo',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: AppColors.whiteWithOpacity,
        fontSize: 18,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildCameraButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _takePhoto(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentWithOpacity,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
      ),
      child: Text(
        'Take Photo',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
