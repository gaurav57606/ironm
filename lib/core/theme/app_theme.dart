import 'package:flutter/material.dart';
import '../constants/ac_colors.dart';
import '../constants/ac_text_styles.dart';

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AcColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AcColors.primary,
        secondary: AcColors.primaryDim,
        surface: AcColors.bg2,
        onSurface: AcColors.textPrimary,
        error: AcColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AcColors.bg,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AcColors.textPrimary),
      ),
      dividerTheme: const DividerThemeData(
        color: AcColors.border,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: AcColors.bg2,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AcColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AcColors.elevation2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AcColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AcColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AcColors.primary, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AcColors.textSecondary, fontSize: 12),
        hintStyle: const TextStyle(color: AcColors.textMuted, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AcColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AcTextStyles.h1,
        headlineMedium: AcTextStyles.h2,
        bodyLarge: AcTextStyles.body,
        bodyMedium: AcTextStyles.bodySecondary,
        labelSmall: AcTextStyles.bodySmall,
      ),
    );
  }
}
