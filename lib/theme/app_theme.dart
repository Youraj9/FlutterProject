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

  static final ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
    textTheme: _textTheme,
    useMaterial3: true,
  );
}
