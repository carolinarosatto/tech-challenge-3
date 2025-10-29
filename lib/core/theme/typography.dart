import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamily = 'Inter';

  // 🧠 Hierarquia de textos:
  // - headline → títulos e seções
  // - body → textos comuns e descrições
  // - label → botões, tags, etc.

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700, // Bold
    fontSize: 24,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600, // Semi-bold
    fontSize: 20,
    letterSpacing: -0.25,
    height: 1.35,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.45,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600, // Medium
    fontSize: 14,
    letterSpacing: 0.1,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    letterSpacing: 0.2,
  );
}
