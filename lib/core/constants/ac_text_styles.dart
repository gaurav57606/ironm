import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ac_colors.dart';

class AcTextStyles {
  static TextStyle _font({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textStyle: TextStyle(letterSpacing: letterSpacing),
    );
  }

  static TextStyle get h1 => _font(fontSize: 32, fontWeight: FontWeight.w900, color: AcColors.textPrimary);
  static TextStyle get h2 => _font(fontSize: 24, fontWeight: FontWeight.w800, color: AcColors.textPrimary);
  static TextStyle get h3 => _font(fontSize: 20, fontWeight: FontWeight.w700, color: AcColors.textPrimary);
  static TextStyle get title => _font(fontSize: 18, fontWeight: FontWeight.w700, color: AcColors.textPrimary);
  static TextStyle get body => _font(fontSize: 14, fontWeight: FontWeight.w400, color: AcColors.textPrimary);
  static TextStyle get bodySecondary => _font(fontSize: 14, fontWeight: FontWeight.w400, color: AcColors.textSecondary);
  static TextStyle get bodySmall => _font(fontSize: 12, fontWeight: FontWeight.w400, color: AcColors.textSecondary);
  static TextStyle get label => _font(fontSize: 12, fontWeight: FontWeight.w600, color: AcColors.textPrimary);
  static TextStyle get subtext => _font(fontSize: 10, fontWeight: FontWeight.w400, color: AcColors.textSecondary);
  static TextStyle get sectionTitle => _font(
    fontSize: 10, fontWeight: FontWeight.w700,
    color: AcColors.textSecondary, letterSpacing: 1.0,
  );
}
