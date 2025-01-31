// lib/text_styles.dart

import 'package:freelance/src/constants/app_colors.dart';
import 'package:flutter/material.dart';

TextTheme buildTextTheme() {
  return const TextTheme(
    headlineSmall: TextStyle(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: AppColors.black),
    headlineMedium: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: AppColors.black),
    headlineLarge: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: AppColors.black),
    bodyLarge: TextStyle(fontSize: 16.0, color: AppColors.black),
    bodyMedium: TextStyle(fontSize: 14.0, color: AppColors.black),
    bodySmall: TextStyle(fontSize: 12.0, color: AppColors.black),
  );
}
