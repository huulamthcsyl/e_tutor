import 'package:flutter/material.dart';

const primaryColor = Color(0xff0D92F4);
const secondaryColor = Color(0xff77CDFF);

final theme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xfffdfdfd),
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    secondary: secondaryColor,
    brightness: Brightness.light,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: primaryColor
    ),
    labelMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: primaryColor
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: primaryColor
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
    ),
  )
);
