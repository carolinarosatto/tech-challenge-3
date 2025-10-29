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
    );
  }
}
