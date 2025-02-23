import 'package:flutter/material.dart';
import 'package:fungi_app/shared/constants/app_colors.dart';

class PageContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const PageContent({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
} 