import 'package:flutter/material.dart';

/// Premium color palette for AI Resume Pro
class AppColors {
  AppColors._();

  // Primary Gradient Colors
  static const Color primaryStart = Color(0xFF6366F1); // Indigo
  static const Color primaryEnd = Color(0xFF8B5CF6); // Violet
  static const Color primaryMid = Color(0xFF7C3AED); // Purple

  // Background Gradient Colors (Dark Theme)
  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color backgroundStart = Color(0xFF0F172A); // Slate 900
  static const Color backgroundEnd = Color(0xFF1E293B); // Slate 800
  static const Color backgroundMid = Color(0xFF1A2332);

  // Surface Colors
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155); // Slate 700
  static const Color surfaceLighter = Color(0xFF475569); // Slate 600

  // Card Colors (Glassmorphism)
  static const Color cardBackground = Color(0x1AFFFFFF); // White 10%
  static const Color cardBorder = Color(0x33FFFFFF); // White 20%
  static const Color cardBackgroundSolid = Color(0xFF252D3D);

  // Accent Colors
  static const Color accent = Color(0xFF22D3EE); // Cyan
  static const Color accentStart = Color(0xFF22D3EE); // Cyan
  static const Color accentEnd = Color(0xFF06B6D4); // Cyan Darker
  static const Color accentGreen = Color(0xFF10B981); // Emerald
  static const Color accentOrange = Color(0xFFF59E0B); // Amber
  static const Color accentPink = Color(0xFFEC4899); // Pink

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCBD5E1); // Slate 300
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color textMuted = Color(0xFF64748B); // Slate 500

  // Input Colors
  static const Color inputBackground = Color(0x0DFFFFFF); // White 5%
  static const Color inputBorder = Color(0x33FFFFFF); // White 20%
  static const Color inputBorderFocused = Color(0xFF6366F1);
  static const Color inputFill = Color(0xFF1E293B);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryStart, primaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundStart, backgroundEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0x1AFFFFFF),
      Color(0x0DFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: primaryStart.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
}
