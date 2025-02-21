import 'package:flutter/material.dart';
import 'package:fungi_app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'modules/pages/camera_page.dart';
import 'modules/pages/gallery_page.dart';
import 'modules/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FungiApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A0E5F),
          primary: const Color(0xFF2A0E5F),
          secondary: const Color(0xFF8B6BFF),
          tertiary: const Color(0xFFFF6BE6),
          background: const Color(0xFF2A0E5F),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
