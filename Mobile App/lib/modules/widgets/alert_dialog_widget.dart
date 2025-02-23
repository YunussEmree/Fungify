import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';

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
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: AppColors.accentWithOpacity,
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
          color: AppColors.whiteWithOpacity,
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
              color: AppColors.highlight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
