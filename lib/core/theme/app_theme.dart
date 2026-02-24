import 'package:flutter/material.dart';

class FoodFeedColors {
  FoodFeedColors._();

  static const deepGreen = Color(0xFF2D5A3D);
  static const deepGreenLight = Color(0xFF3A7350);
  static const deepGreenSoft = Color(0xFF4A8C63);
  static const offWhite = Color(0xFFF8F6F2);
  static const warmWhite = Color(0xFFFAF9F6);
  static const cream = Color(0xFFF3EDE4);
  static const warmGray = Color(0xFF8C8478);
  static const darkText = Color(0xFF2C2A26);
  static const mutedText = Color(0xFF6B665E);
  static const tagBg = Color(0xFFE8F0E6);
  static const tagText = Color(0xFF3A6B4A);
  static const accentAmber = Color(0xFFD4A853);
  static const timelineLine = Color(0xFFD4CEC4);
  static const timelineDot = Color(0xFF3A7350);
}

class AppTheme {
  AppTheme._();

  static const _seedColor = Color(0xFF6750A4);

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 24.0;

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        filled: true,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusLarge),
          ),
        ),
        showDragHandle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
    );
  }
}
