import 'package:flutter/material.dart';

class AppColors {
  // Brand / Primary Colors
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color accent;

  // Backgrounds & Surface Colors (for glassmorphism)
  final Color background;
  final Color backgroundGradientEnd;
  final Color cardBackground;
  final Color cardBorder;

  // Text Colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textLight;

  // Semantic/Status Colors
  final Color success;
  final Color error;
  final Color warning;
  final Color info;

  // Greys for generic UI borders, etc.
  final Color greyPrimary;
  final Color greyLight;
  final Color greyMedium;
  final Color greyExtraLight;

  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.accent,
    required this.background,
    required this.backgroundGradientEnd,
    required this.cardBackground,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLight,
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.greyPrimary,
    required this.greyLight,
    required this.greyMedium,
    required this.greyExtraLight,
  });

  ///  Weather Task App - Light Theme Colors 
  static const AppColors light = AppColors(
    primary: Color(0xFF0F52BA),          // Royal Blue
    primaryDark: Color(0xFF002D62),      // Deep Navy
    primaryLight: Color(0xFFEAF2FF),     // Light Blue Tint
    accent: Color(0xFF4CA6FF),           // Sky Blue
    background: Color(0xFFE0F0FF),       // Soft Sky Gradient Start
    backgroundGradientEnd: Color(0xFFF0F6FF), // Soft Sky Gradient End
    cardBackground: Color(0xB3FFFFFF),   // Glassmorphic card (White with 70% opacity)
    cardBorder: Color(0x33FFFFFF),       // Card border with 20% opacity
    textPrimary: Color(0xFF002244),      // Dark navy blue text
    textSecondary: Color(0xFF203A54),    // Darker slate blue for high readability in light mode
    textLight: Color(0xFFFFFFFF),        // White text
    success: Color(0xFF31B042),
    error: Color(0xFFD63B3B),
    warning: Color(0xFFE8943A),
    info: Color(0xFF0066FF),
    greyPrimary: Color(0xFF9E9E9E),
    greyLight: Color(0xFFCECECE),
    greyMedium: Color(0xFFC7C7C7),
    greyExtraLight: Color(0xFFE0E0E0),
  );

  ///  Weather Task App - Dark Theme Colors
  static const AppColors dark = AppColors(
    primary: Color(0xFF5CA4FF),          // Soft light blue for contrast
    primaryDark: Color(0xFF00449E),
    primaryLight: Color(0xFF1E293B),     // Slate dark
    accent: Color(0xFF4CA6FF),
    background: Color(0xFF0B132B),       // Midnight dark blue
    backgroundGradientEnd: Color(0xFF1C2541), // Deep navy blue
    cardBackground: Color(0x1FFFFFFF),   // Dark glassmorphic card (White with 12% opacity)
    cardBorder: Color(0x1FBDC9D8),       // Glassmorphic border with 12% opacity
    textPrimary: Color(0xFFF1F5F9),      // Light white-grey text
    textSecondary: Color(0xFFE2E8F0),    // Brighter silver grey for high contrast readability in dark mode
    textLight: Color(0xFFFFFFFF),
    success: Color(0xFF4ADE80),
    error: Color(0xFFF87171),
    warning: Color(0xFFFBBF24),
    info: Color(0xFF60A5FA),
    greyPrimary: Color(0xFFCBD5E1),
    greyLight: Color(0xFF475569),
    greyMedium: Color(0xFF94A3B8),
    greyExtraLight: Color(0xFF334155),
  );
}
