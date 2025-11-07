import 'package:flutter/material.dart';

import 'typography.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brand500,
        secondary: AppColors.brand300,
        surface: AppColors.background100,
        onPrimary: AppColors.text100,
        onSurface: AppColors.text300,
        error: AppColors.stateError,
      ),
      fontFamily: AppTypography.fontFamily,
      textTheme: const TextTheme(
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        labelLarge: AppTypography.labelLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size(double.infinity, 48.0),
          textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: Size(double.infinity, 48.0),
          textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: AppColors.text100),
      ),
    );
  }
}
