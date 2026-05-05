import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color.fromARGB(255, 103, 186, 107);
  static const Color primaryLight = Color.fromARGB(255, 93, 167, 90);
  static const Color primaryDark = Color.fromARGB(255, 28, 169, 37);

  // Secondary Colors
  static const Color secondary = Color(0xFFFFA000);
  static const Color secondaryLight = Color(0xFFFFD149);
  static const Color secondaryDark = Color(0xFFC67100);

  // Accent Colors
  static const Color accent = Color(0xFF1976D2);
  static const Color accentLight = Color(0xFF63A4FF);
  static const Color accentDark = Color(0xFF004BA0);

  // Semantic Colors
  static const Color success = Color.fromARGB(255, 93, 218, 97);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Food Category Colors
  static const Color carbohydrates = Color(0xFFFFB74D);
  static const Color protein = Color(0xFFEF5350);
  static const Color vegetables = Color(0xFF66BB6A);
  static const Color fruits = Color(0xFFAB47BC);
  static const Color dairy = Color(0xFF42A5F5);
  static const Color fats = Color(0xFFFFA726);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color.fromARGB(255, 103, 186, 107),
    Color.fromARGB(255, 93, 167, 90),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF1976D2),
    Color(0xFF42A5F5),
  ];

  // Shadows
  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  static BoxShadow buttonShadow = BoxShadow(
    color: primary.withOpacity(0.3),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
}
