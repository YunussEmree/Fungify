import 'package:flutter/material.dart';
import 'package:fungify/modules/widgets/app_header.dart';
import 'package:fungify/modules/widgets/bottom_navigation.dart';
import 'package:fungify/modules/widgets/main_content.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF2A0E5F),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            AppHeader(),
            SizedBox(height: 20),
            Expanded(child: MainContent()),
            BottomNavigation(),
          ],
        ),
      ),
    );
  }
}
