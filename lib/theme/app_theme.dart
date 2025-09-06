// app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Main color scheme
  static const Color primaryColor = Color(0xFF833AB4); // Instagram gradient start
  static const Color secondaryColor = Color(0xFFF77737); // Instagram gradient middle
  static const Color accentColor = Color(0xFFE1306C); // Instagram pinkish
  static const Color backgroundColor = Colors.white;
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color iconColor = Colors.black87;
  static const Color textColor = Colors.black87;

  // Text Styles
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    color: textColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  // ThemeData for MaterialApp
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: accentColor,
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    backgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: iconColor),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      centerTitle: true,
    ),
    iconTheme: const IconThemeData(color: iconColor),
    textTheme: const TextTheme(
      headline1: headline1,
      headline2: headline2,
      bodyText1: bodyText1,
      bodyText2: bodyText2,
      caption: caption,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    useMaterial3: true,
    fontFamily: 'Roboto', // Instagram-style font
  );
}
