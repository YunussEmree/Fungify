import 'package:flutter/material.dart';
import 'package:fungify/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fungify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A0E5F),
          primary: const Color(0xFF2A0E5F),
          secondary: const Color(0xFF8B6BFF),
          tertiary: const Color(0xFFFF6BE6),
          surface: const Color(0xFF2A0E5F),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
