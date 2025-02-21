import 'package:flutter/material.dart';
import 'package:fungi_app/modules/main_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Galeri ekranı widget'ı
/// Kullanıcının galeriden fotoğraf seçmesini ve API'ye göndermesini sağlar
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A0E5F), // Ana arka plan rengi
      appBar: AppBar(
        title: Text(
          'Galeriden Seç',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ana konteyner
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF3D1B7A)
                        .withOpacity(0.6), // Gradient başlangıç rengi
                    const Color(0xFF2A0E5F)
                        .withOpacity(0.3), // Gradient bitiş rengi
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF8B6BFF).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // İkon konteynerı
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF8B6BFF).withOpacity(0.3),
                          const Color(0xFFFF6BE6).withOpacity(0.3),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      size: 80,
                      color: const Color(0xFFFF6BE6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bilgilendirme metni
                  Text(
                    'Galeriden bir fotoğraf seçin',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Fotoğraf seçme butonu
                  ElevatedButton(
                    onPressed: () =>
                        Get.find<MainController>().pickImage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B6BFF).withOpacity(0.2),
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
                      'Fotoğraf Seç',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
