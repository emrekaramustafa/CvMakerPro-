import 'package:flutter/material.dart';

/// Premium color palette for AI Resume Pro
/// Supports both dark and light modes via AppColorsDynamic
class AppColors {
  AppColors._();

  // ─── DARK PALETTE (Executive & Creative) ───
  // Primary Action Colors (Electric Violet -> Indigo)
  static const Color primaryStart = Color(0xFF6366F1); // Indigo 500
  static const Color primaryEnd = Color(0xFF8B5CF6);   // Violet 500
  static const Color primaryMid = Color(0xFF7C3AED);   // Violet 600

  // Backgrounds (Midnight Blue Theme)
  static const Color background = Color(0xFF020617);      // Slate 950 (Deepest)
  static const Color backgroundStart = Color(0xFF020617); // Slate 950
  static const Color backgroundEnd = Color(0xFF0F172A);   // Slate 900
  static const Color backgroundMid = Color(0xFF1E293B);   // Slate 800

  // Surfaces (Cards, Dialogs)
  static const Color surface = Color(0xFF0F172A);         // Slate 900
  static const Color surfaceLight = Color(0xFF1E293B);    // Slate 800
  static const Color surfaceLighter = Color(0xFF334155);  // Slate 700

  // Card specifics
  static const Color cardBackground = Color(0x0DFFFFFF);  // Glass effect
  static const Color cardBorder = Color(0x1FFFFFFF);      // Subtle border
  static const Color cardBackgroundSolid = Color(0xFF1E293B); // Slate 800

  // Accents (Technical & Vivid)
  static const Color accent = Color(0xFF38BDF8);          // Sky 400
  static const Color accentStart = Color(0xFF38BDF8);
  static const Color accentEnd = Color(0xFF0EA5E9);       // Sky 500
  static const Color accentGreen = Color(0xFF10B981);     // Emerald 500
  static const Color accentOrange = Color(0xFFF59E0B);    // Amber 500
  static const Color accentPink = Color(0xFFEC4899);      // Pink 500
  static const Color accentPurple = Color(0xFFC084FC);    // Purple 400

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);     // Slate 50
  static const Color textSecondary = Color(0xFFCBD5E1);   // Slate 300
  static const Color textTertiary = Color(0xFF94A3B8);    // Slate 400
  static const Color textMuted = Color(0xFF64748B);       // Slate 500

  // Inputs
  static const Color inputBackground = Color(0xFF0F172A); // Slate 900
  static const Color inputBorder = Color(0xFF334155);     // Slate 700
  static const Color inputBorderFocused = Color(0xFF8B5CF6); // Violet 500
  static const Color inputFill = Color(0xFF0F172A);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ─── GRADIENTS ───
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Indigo to Violet
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF020617), Color(0xFF0F172A)], // Deep Midnight
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF818CF8)], // Sky to Indigo
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)], // Slate 800 to 900
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── SHADOWS ───
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF000000).withOpacity(0.4),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: const Color(0xFF8B5CF6).withOpacity(0.25),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
}

/// Premium LIGHT mode palette — Professional & Clean
class AppColorsLight {
  AppColorsLight._();

  // Primary
  static const Color primaryStart = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryEnd = Color(0xFF7C3AED);   // Violet 600
  static const Color primaryMid = Color(0xFF6366F1);   // Indigo 500

  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);      // Slate 50
  static const Color backgroundStart = Color(0xFFF8FAFC);
  static const Color backgroundEnd = Color(0xFFF1F5F9);   // Slate 100
  static const Color backgroundMid = Color(0xFFFFFFFF);

  // Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color surfaceLighter = Color(0xFFF1F5F9);

  // Cards
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);      // Slate 200
  static const Color cardBackgroundSolid = Color(0xFFFFFFFF);

  // Accents
  static const Color accent = Color(0xFF0EA5E9);          // Sky 500
  static const Color accentStart = Color(0xFF0EA5E9);
  static const Color accentEnd = Color(0xFF0284C7);       // Sky 600
  static const Color accentGreen = Color(0xFF059669);     // Emerald 600
  static const Color accentOrange = Color(0xFFD97706);    // Amber 600
  static const Color accentPink = Color(0xFFDB2777);      // Pink 600
  static const Color accentPurple = Color(0xFFA855F7);    // Purple 500

  // Text
  static const Color textPrimary = Color(0xFF0F172A);     // Slate 900
  static const Color textSecondary = Color(0xFF475569);   // Slate 600
  static const Color textTertiary = Color(0xFF94A3B8);    // Slate 400
  static const Color textMuted = Color(0xFFCBD5E1);       // Slate 300

  // Inputs
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFE2E8F0);     // Slate 200
  static const Color inputBorderFocused = Color(0xFF6366F1); // Indigo 500
  static const Color inputFill = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF059669);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFD97706);
  static const Color info = Color(0xFF2563EB);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF64748B).withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: const Color(0xFF4F46E5).withOpacity(0.15),
      blurRadius: 16,
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
  Color get accentPurple => isDark ? AppColors.accentPurple : AppColorsLight.accentPurple;

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
