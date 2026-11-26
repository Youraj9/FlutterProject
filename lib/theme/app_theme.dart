import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color _seedColor = Color(0xFFFF5A1F);

  static final TextTheme _baseTextTheme = ThemeData.light().textTheme;

  static final TextTheme _textTheme = GoogleFonts.plusJakartaSansTextTheme(
    _baseTextTheme.copyWith(
      bodySmall: _baseTextTheme.bodySmall?.copyWith(fontSize: 14),
      bodyMedium: _baseTextTheme.bodyMedium?.copyWith(fontSize: 15),
      bodyLarge: _baseTextTheme.bodyLarge?.copyWith(fontSize: 16),
    ),
  );

  static final ThemeData light = _buildTheme(Brightness.light);

  static final ThemeData dark = _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: brightness,
        ).copyWith(
          surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          surfaceContainerLowest: isDark
              ? const Color(0xFF121212)
              : Colors.white,
          surfaceContainerLow: isDark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFFFAFAFA),
          surfaceContainer: isDark
              ? const Color(0xFF222222)
              : const Color(0xFFF5F5F5),
          surfaceContainerHigh: isDark
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFEEEEEE),
          surfaceContainerHighest: isDark
              ? const Color(0xFF333333)
              : const Color(0xFFE8E8E8),
          outlineVariant: isDark
              ? const Color(0xFF424242)
              : const Color(0xFFE5E5E5),
        );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      useMaterial3: true,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFAFAFA),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF18243B),
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark
            ? const Color(0xFF2C2C2C)
            : const Color(0xFF18243B),
      ),
      dividerColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5),
    );
  }
}
