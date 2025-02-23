import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget(
      {super.key,
      required this.action,
      required this.subtitle,
      required this.title});
  final String title;
  final String subtitle;
  final String action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2A0E5F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Color.fromARGB(77, 139, 107, 255), // 0.3 * 255 ≈ 77 for alpha
          width: 1,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        subtitle,
        style: GoogleFonts.poppins(
          color: Color.fromARGB(230, 255, 255, 255), // 0.9 * 255 ≈ 230 for alpha
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dialog'u kapat
            Navigator.of(context).pop(); // Galeri ekranını kapat
          },
          child: Text(
            action,
            style: GoogleFonts.poppins(
              color: const Color(0xFFFF6BE6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
