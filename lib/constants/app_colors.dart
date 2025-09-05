import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF833AB4); // Instagram purple
  static const Color primaryLight = Color(0xFFBC2A8D);
  static const Color primaryDark = Color(0xFF4C68D7);

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF8F8F8);

  // Text colors
  static const Color textPrimary = Color(0xFF262626); // main text
  static const Color textSecondary = Color(0xFF8E8E8E); // grey text
  static const Color textWhite = Color(0xFFFFFFFF);

  // Buttons
  static const Color buttonPrimary = Color(0xFF3897F0);
  static const Color buttonDisabled = Color(0xFFB2DFFC);

  // Borders & dividers
  static const Color border = Color(0xFFDBDBDB);
  static const Color divider = Color(0xFFE0E0E0);

  // Notifications & status
  static const Color likeRed = Color(0xFFE1306C);
  static const Color commentBlue = Color(0xFF3897F0);
  static const Color storyGradientStart = Color(0xFFFEDA77);
  static const Color storyGradientEnd = Color(0xFFF58529);

  // Shadows
  static const Color shadow = Colors.black26;

  // Gradient example
  static LinearGradient storyGradient = const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      storyGradientStart,
      storyGradientEnd,
      primary,
    ],
  );
}
