import 'package:flutter/material.dart';

class AcColors {
  // Backgrounds — premium dark layered system matching HTML design
  static const Color bg          = Color(0xFF0B0E17);
  static const Color s1          = Color(0xFF131825);
  static const Color s2          = Color(0xFF1A2133);
  static const Color s3          = Color(0xFF222B3D);
  static const Color bg2         = Color(0xFF131825); // compatibility alias
  static const Color bg3         = Color(0xFF1A2133); // compatibility alias
  static const Color bg4         = Color(0xFF222B3D); // compatibility alias

  // Brand — glowing orange accent
  static const Color primary     = Color(0xFFF97316);
  static const Color primaryDim  = Color(0xFFEA6A0E);
  static const Color brandL      = Color(0x1EF97316); // 12% opacity
  static const Color brandD      = Color(0x40F97316); // 25% opacity

  // Semantic
  static const Color active      = Color(0xFF22C55E);
  static const Color expiring    = Color(0xFFF59E0B);
  static const Color expired     = Color(0xFFF43F5E);
  static const Color warning     = Color(0xFFF59E0B);
  static const Color success     = Color(0xFF22C55E);
  static const Color error       = Color(0xFFF43F5E);
  static const Color blue        = Color(0xFF38BDF8);
  static const Color purple      = Color(0xFFA78BFA);

  // Text
  static const Color textPrimary   = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0x99F1F5F9); // 60% opacity
  static const Color textMuted     = Color(0x4DF1F5F9); // 30% opacity

  // UI
  static const Color rim         = Color(0x12FFFFFF); // 7% opacity white
  static const Color rim2        = Color(0x1EFFFFFF); // 12% opacity white
  static const Color border      = Color(0x1EFFFFFF); // matches rim2
  static const Color divider     = Color(0x12FFFFFF); // matches rim
  static const Color elevation2  = Color(0xFF131825); // matches s1
  static const Color elevation3  = Color(0xFF1A2133); // matches s2

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0D1220), bg],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
