// core/theme/app_colors.dart

// 1. Primary Color:
// Teal (#008080): Teal gives a fresh and modern feel, and it's a calming color, which is great for an app that might be used frequently.
// 2. Secondary Color:
// Coral (#FF6F61): Coral adds a vibrant contrast to teal, making buttons or important features stand out without being too aggressive.
// 3. Background Color:
// Light Gray (#F2F2F2): A light gray background provides a neutral canvas that allows the primary and secondary colors to pop.
// 4. Accent Color:
// Mustard Yellow (#FFC107): Mustard yellow can be used for highlights, icons, or important alerts, adding a touch of warmth and energy.
// 5. Text Color:
// Dark Slate Gray (#2F4F4F): For text, dark slate gray provides a strong contrast against the light gray background while being softer on the eyes than pure black.
// 6. Success/Positive Color:
// Emerald Green (#50C878): Use this for success messages or indicators, as green is often associated with positive outcomes.
// 7. Error/Warning Color:
// Crimson Red (#DC143C): For error messages or warnings, crimson red is bold and catches attention immediately.
// 8. Neutral Color:
// White (#FFFFFF): For elements that need to remain neutral or for providing separation between different sections.

import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color lightPrimary = Color(0xFFFFB600);
  static const Color lightPrimaryVariant = Color(0xFFC79100);
  static const Color lightSecondary = Color(0xFFB6B6B6); // Vibrant Blue
  static const Color lightSurface = Color(0xFFFFFFFF); // background
  static const Color lightError = Color(0xFFD32F2F); // Deep Red
  static const Color lightOnPrimary = Color(0xFFFFFFFF); // Black (for contrast with yellow)
  static const Color lightOnSecondary = Color(0xFFFFFFFF); // White (on blue)
  static const Color lightOnSurface = Color(0xFF333333); // Dark Gray
  static const Color lightOnError = Color(0xFFFFFFFF); // White
  static const Color commonRed = Color(0xFFD32F2F); // Deep Red// grayish blue
  static const Color commonGreyText = Color(0xFFb8bac0); // grayish blue




// Dark theme colors
// Updated Dark theme colors for dark mode
  static const Color darkPrimary = Color(0xFF1C1C1C);
  static const Color darkPrimaryVariant = Color(0xFFCC8400);
  static const Color darkSecondary = Color(0xFF9F7CFF);
  static const Color darkSurface = Color(0xFF1C1C1C);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnPrimary = Color(0xFFffffff);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFffffff);
  static const Color darkOnError = Color(0xFF000000);
}
