import 'package:flutter/material.dart';

class AcColors {
  // Backgrounds — dark layered system
  static const Color bg          = Color(0xFF0C0C0E);
  static const Color bg2         = Color(0xFF141417);
  static const Color bg3         = Color(0xFF1C1C21);
  static const Color bg4         = Color(0xFF242429);

  // Brand — orange accent (same as iron_g for visual consistency)
  static const Color primary     = Color(0xFFFF6B2B);
  static const Color primaryDim  = Color(0xFFCC4A15);

  // Semantic
  static const Color active      = Color(0xFF22C55E);
  static const Color expiring    = Color(0xFFF59E0B);
  static const Color expired     = Color(0xFFEF4444);
  static const Color warning     = Color(0xFFF59E0B);
  static const Color success     = Color(0xFF22C55E);
  static const Color error       = Color(0xFFEF4444);
  static const Color blue        = Color(0xFF3B82F6);

  // Text
  static const Color textPrimary   = Color(0xFFF0EEF6);
  static const Color textSecondary = Color(0xFF9896A4);
  static const Color textMuted     = Color(0xFF5C5A67);

  // UI
  static const Color border      = Color(0xFF2A2A30);
  static const Color divider     = Color(0xFF1C1C21);
  static const Color elevation2  = Color(0xFF1C1C21);
  static const Color elevation3  = Color(0xFF242429);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF922B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [bg, Color(0xFF141417)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
