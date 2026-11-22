import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DopamineColors {
  static const pink = Color(0xFFFF416C);
  static const brightPink = Color(0xFFFF61D8);
  static const purple = Color(0xFF8E2DE2);
  static const deepPurple = Color(0xFF4A00E0);
  static const orange = Color(0xFFFF8008);
  static const yellow = Color(0xFFFFC837);
  static const mint = Color(0xFF00F5A0);
  static const cyan = Color(0xFF00D2FF);
  static const neonBlue = Color(0xFF3B82F6);
  static const cardBg = Color(0xF0FFFFFF);
  static const scaffold = Color(0xFFF8FAFC);
  static const slate900 = Color(0xFF0F172A);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DopamineColors.purple,
        primary: DopamineColors.purple,
        secondary: DopamineColors.pink,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: DopamineColors.scaffold,
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: const Color(0xFF1E293B),
      displayColor: const Color(0xFF0F172A),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: DopamineColors.slate900,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DopamineColors.pink,
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DopamineColors.slate900.withValues(alpha: 0.95),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

Color meterBg(String color) {
  switch (color) {
    case 'amber':
      return const Color(0xFFFFFBEB);
    case 'cyan':
      return const Color(0xFFECFEFF);
    case 'purple':
      return const Color(0xFFFAF5FF);
    case 'pink':
      return const Color(0xFFFDF2F8);
    default:
      return const Color(0xFFF8FAFC);
  }
}

Color statusBadgeColor(String key) {
  switch (key) {
    case 'emerald':
      return const Color(0xFF10B981);
    case 'amber':
      return const Color(0xFFF59E0B);
    case 'slate':
      return const Color(0xFF64748B);
    default:
      return const Color(0xFF10B981);
  }
}
