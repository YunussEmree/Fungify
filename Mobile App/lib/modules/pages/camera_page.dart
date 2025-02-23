import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fungi_app/modules/widgets/gradient_container.dart';
import 'package:fungi_app/modules/widgets/alert_dialog_widget.dart';
import 'package:fungi_app/modules/main_controller.dart';
import 'package:get/get.dart';

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
        await Get.find<MainController>().pickImage(context, imagePath: photo.path);
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialogWidget(
            title: 'Error',
            subtitle: 'An error occurred while taking the photo. Please try again.',
            action: 'OK',
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A0E5F),
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Take Photo',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
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
            const Color(0xFF8B6BFF).withAlpha(77), // 0.3 opacity
            const Color(0xFFFF6BE6).withAlpha(77), // 0.3 opacity
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.camera_alt_rounded,
        size: 80,
        color: Color(0xFFFF6BE6),
      ),
    );
  }

  Widget _buildInstructionText() {
    return Text(
      'Use the camera to take\na mushroom photo',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        color: const Color.fromARGB(230, 255, 255, 255),
        fontSize: 18,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildCameraButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _takePhoto(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(51, 139, 107, 255),
        foregroundColor: Colors.white,
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
