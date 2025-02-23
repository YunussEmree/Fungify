import 'package:flutter/material.dart';
import 'package:fungi_app/modules/main_controller.dart';
import 'package:fungi_app/modules/widgets/fungy_detail_dialog.dart';
import 'package:fungi_app/modules/widgets/gradient_container.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';
import 'package:fungi_app/shared/constants/app_text_styles.dart';
import 'package:get/get.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Select from Gallery',
        style: AppTextStyles.button.copyWith(color: AppColors.white),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientContainer(
            child: _buildGalleryContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGalleryIcon(),
        const SizedBox(height: 20),
        _buildInstructionText(),
        const SizedBox(height: 30),
        _buildSelectButton(),
      ],
    );
  }

  Widget _buildGalleryIcon() {
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
        Icons.photo_library_rounded,
        size: 80,
        color: AppColors.highlight,
      ),
    );
  }

  Widget _buildInstructionText() {
    return Text(
      'Select a photo from gallery',
      style: AppTextStyles.body.copyWith(fontSize: 18),
    );
  }

  Widget _buildSelectButton() {
    return ElevatedButton(
      onPressed: () => _selectAndProcessImage(Get.context!),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent.withAlpha(51),
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
        'Select Photo',
        style: AppTextStyles.button,
      ),
    );
  }

  Future<void> _selectAndProcessImage(BuildContext context) async {
    final result = await Get.find<MainController>().pickImage(context);
    if (result != null && context.mounted) {
      Get.dialog(
        FungyDetailDialog(fungy: result),
        barrierDismissible: false,
      );
    }
  }
}
