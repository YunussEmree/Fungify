import 'package:flutter/material.dart';
import 'package:fungi_app/modules/main_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fungi_app/modules/widgets/gradient_container.dart';

/// Galeri ekranı widget'ı
/// Kullanıcının galeriden fotoğraf seçmesini ve API'ye göndermesini sağlar
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A0E5F),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Select from Gallery',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
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
            const Color(0xFF8B6BFF).withAlpha(77), // 0.3 opacity
            const Color(0xFFFF6BE6).withAlpha(77), // 0.3 opacity
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.photo_library_rounded,
        size: 80,
        color: Color(0xFFFF6BE6),
      ),
    );
  }

  Widget _buildInstructionText() {
    return Text(
      'Select a photo from gallery',
      style: GoogleFonts.poppins(
        color: const Color.fromARGB(230, 255, 255, 255),
        fontSize: 18,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildSelectButton() {
    return ElevatedButton(
      onPressed: () => Get.find<MainController>().pickImage(Get.context!),
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
        'Select Photo',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
