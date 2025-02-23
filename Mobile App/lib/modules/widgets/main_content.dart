import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3D1B7A).withAlpha(153),
            const Color(0xFF2A0E5F).withAlpha(77),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImageContainer(),
          const SizedBox(height: 30),
          _buildInstructionContainer(),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF8B6BFF).withAlpha(77),
            const Color(0xFFFF6BE6).withAlpha(77),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8B6BFF).withAlpha(77),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/mushroom.png',
          height: 180,
          width: 180,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInstructionContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF8B6BFF).withAlpha(51),
            const Color(0xFFFF6BE6).withAlpha(51),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF8B6BFF).withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.camera_enhance_rounded,
            color: Color(0xFFFF6BE6), 
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            'Kamera ile sınıflandırmaya başlamak için\nkamera ikonuna tıklayınız.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white.withAlpha(230),
              fontSize: 16,
              height: 1.5,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
} 