import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme configuration with Material 3
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // Blue-teal color palette for water theming
  static const Color _primaryLight = Color(0xFF0288D1); // Light Blue 700
  static const Color _secondaryLight = Color(0xFF00BCD4); // Cyan 500
  static const Color _tertiaryLight = Color(0xFF26C6DA); // Cyan 400
  static const Color _surfaceLight = Color(0xFFF5F5F5);
  static const Color _backgroundLight = Color(0xFFFFFFFF);

  static const Color _primaryDark = Color(0xFF4FC3F7); // Light Blue 300
  static const Color _secondaryDark = Color(0xFF26C6DA); // Cyan 400
  static const Color _tertiaryDark = Color(0xFF00BCD4); // Cyan 500
  static const Color _surfaceDark = Color(0xFF1E1E1E);
  static const Color _backgroundDark = Color(0xFF121212);

  /// Light theme configuration
  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.light(
      primary: _primaryLight,
      secondary: _secondaryLight,
      tertiary: _tertiaryLight,
      surface: _surfaceLight,
      surfaceContainerLow: _backgroundLight,
    );

    return _buildTheme(colorScheme);
  }

  /// Dark theme configuration
  static ThemeData darkTheme() {
    final colorScheme = ColorScheme.dark(
      primary: _primaryDark,
      secondary: _secondaryDark,
      tertiary: _tertiaryDark,
      surface: _surfaceDark,
      surfaceContainerLow: _backgroundDark,
    );

    return _buildTheme(colorScheme);
  }

  /// Build theme with Material 3 and Google Fonts
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: colorScheme.surfaceContainerLow,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
