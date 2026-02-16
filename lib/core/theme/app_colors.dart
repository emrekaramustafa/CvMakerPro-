import 'package:flutter/material.dart';

/// Premium color palette for AI Resume Pro
/// Supports both dark and light modes via AppColorsDynamic
class AppColors {
  AppColors._();

  // ─── DARK PALETTE (original) ───
  static const Color primaryStart = Color(0xFF6366F1);
  static const Color primaryEnd = Color(0xFF8B5CF6);
  static const Color primaryMid = Color(0xFF7C3AED);

  static const Color background = Color(0xFF0F172A);
  static const Color backgroundStart = Color(0xFF0F172A);
  static const Color backgroundEnd = Color(0xFF1E293B);
  static const Color backgroundMid = Color(0xFF1A2332);

  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155);
  static const Color surfaceLighter = Color(0xFF475569);

  static const Color cardBackground = Color(0x1AFFFFFF);
  static const Color cardBorder = Color(0x33FFFFFF);
  static const Color cardBackgroundSolid = Color(0xFF252D3D);

  static const Color accent = Color(0xFF22D3EE);
  static const Color accentStart = Color(0xFF22D3EE);
  static const Color accentEnd = Color(0xFF06B6D4);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentPink = Color(0xFFEC4899);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static const Color inputBackground = Color(0x0DFFFFFF);
  static const Color inputBorder = Color(0x33FFFFFF);
  static const Color inputBorderFocused = Color(0xFF6366F1);
  static const Color inputFill = Color(0xFF1E293B);

  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ─── GRADIENTS ───
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
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── SHADOWS ───
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

/// Premium LIGHT mode palette — store-screenshot-ready
class AppColorsLight {
  AppColorsLight._();

  // Primary stays the same for brand consistency
  static const Color primaryStart = Color(0xFF6366F1);
  static const Color primaryEnd = Color(0xFF8B5CF6);
  static const Color primaryMid = Color(0xFF7C3AED);

  // Backgrounds
  static const Color background = Color(0xFFF7F8FC);
  static const Color backgroundStart = Color(0xFFF7F8FC);
  static const Color backgroundEnd = Color(0xFFEEF0F7);
  static const Color backgroundMid = Color(0xFFF1F3F8);

  // Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF1F5F9);
  static const Color surfaceLighter = Color(0xFFE2E8F0);

  // Cards
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color cardBackgroundSolid = Color(0xFFFFFFFF);

  // Accents
  static const Color accent = Color(0xFF0EA5E9);
  static const Color accentStart = Color(0xFF0EA5E9);
  static const Color accentEnd = Color(0xFF0284C7);
  static const Color accentGreen = Color(0xFF059669);
  static const Color accentOrange = Color(0xFFD97706);
  static const Color accentPink = Color(0xFFDB2777);

  // Text — dark on light
  static const Color textPrimary = Color(0xFF1A1D26);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFFCBD5E1);

  // Inputs
  static const Color inputBackground = Color(0xFFF8FAFC);
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color inputBorderFocused = Color(0xFF6366F1);
  static const Color inputFill = Color(0xFFF8FAFC);

  // Status
  static const Color success = Color(0xFF059669);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFD97706);
  static const Color info = Color(0xFF2563EB);

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
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF6366F1).withOpacity(0.06),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: primaryStart.withOpacity(0.15),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
}

/// Dynamic color resolver — use `C.of(context).xxx`
class AppColorsDynamic {
  final bool isDark;

  const AppColorsDynamic._(this.isDark);

  factory AppColorsDynamic.of(BuildContext context) {
    return AppColorsDynamic._(Theme.of(context).brightness == Brightness.dark);
  }

  // Primary
  Color get primaryStart => isDark ? AppColors.primaryStart : AppColorsLight.primaryStart;
  Color get primaryEnd => isDark ? AppColors.primaryEnd : AppColorsLight.primaryEnd;
  Color get primaryMid => isDark ? AppColors.primaryMid : AppColorsLight.primaryMid;

  // Background
  Color get background => isDark ? AppColors.background : AppColorsLight.background;
  Color get backgroundStart => isDark ? AppColors.backgroundStart : AppColorsLight.backgroundStart;
  Color get backgroundEnd => isDark ? AppColors.backgroundEnd : AppColorsLight.backgroundEnd;

  // Surface
  Color get surface => isDark ? AppColors.surface : AppColorsLight.surface;
  Color get surfaceLight => isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight;

  // Card
  Color get cardBackground => isDark ? AppColors.cardBackground : AppColorsLight.cardBackground;
  Color get cardBorder => isDark ? AppColors.cardBorder : AppColorsLight.cardBorder;
  Color get cardBackgroundSolid => isDark ? AppColors.cardBackgroundSolid : AppColorsLight.cardBackgroundSolid;

  // Accent
  Color get accent => isDark ? AppColors.accent : AppColorsLight.accent;
  Color get accentGreen => isDark ? AppColors.accentGreen : AppColorsLight.accentGreen;
  Color get accentOrange => isDark ? AppColors.accentOrange : AppColorsLight.accentOrange;
  Color get accentPink => isDark ? AppColors.accentPink : AppColorsLight.accentPink;

  // Text
  Color get textPrimary => isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;
  Color get textSecondary => isDark ? AppColors.textSecondary : AppColorsLight.textSecondary;
  Color get textTertiary => isDark ? AppColors.textTertiary : AppColorsLight.textTertiary;
  Color get textMuted => isDark ? AppColors.textMuted : AppColorsLight.textMuted;

  // Input
  Color get inputBackground => isDark ? AppColors.inputBackground : AppColorsLight.inputBackground;
  Color get inputBorder => isDark ? AppColors.inputBorder : AppColorsLight.inputBorder;
  Color get inputFill => isDark ? AppColors.inputFill : AppColorsLight.inputFill;

  // Status
  Color get success => isDark ? AppColors.success : AppColorsLight.success;
  Color get error => isDark ? AppColors.error : AppColorsLight.error;
  Color get warning => isDark ? AppColors.warning : AppColorsLight.warning;
  Color get info => isDark ? AppColors.info : AppColorsLight.info;

  // Gradients
  LinearGradient get primaryGradient => isDark ? AppColors.primaryGradient : AppColorsLight.primaryGradient;
  LinearGradient get backgroundGradient => isDark ? AppColors.backgroundGradient : AppColorsLight.backgroundGradient;
  LinearGradient get cardGradient => isDark ? AppColors.cardGradient : AppColorsLight.cardGradient;
  LinearGradient get accentGradient => isDark ? AppColors.accentGradient : AppColorsLight.accentGradient;

  // Shadows
  List<BoxShadow> get cardShadow => isDark ? AppColors.cardShadow : AppColorsLight.cardShadow;
  List<BoxShadow> get glowShadow => isDark ? AppColors.glowShadow : AppColorsLight.glowShadow;
}
