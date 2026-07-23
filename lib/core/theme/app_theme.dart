import 'package:flutter/material.dart';
import 'package:weather_task_app/core/theme/app_colors.dart';
import 'package:weather_task_app/core/theme/app_theme_extension.dart';
import 'package:weather_task_app/core/theme/app_text_theme.dart';

class AppTheme {
  // LIGHT THEME 

  static AppThemeExtension lightExtension = const AppThemeExtension(
    colors: AppColors.light,
  );

  static ThemeData lightTheme = ThemeData(
    extensions: [lightExtension],
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.light.background,

    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.light.background,
    ),

    cardColor: AppColors.light.cardBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.light.primary),
    ),

    shadowColor: AppColors.light.textPrimary,

    iconTheme: IconThemeData(color: AppColors.light.primary),

    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.light.primaryDark,
        onPrimary: AppColors.light.textLight,
        secondary: AppColors.light.background,
        onSecondary: AppColors.light.textPrimary,
        tertiary: AppColors.light.accent,
        onTertiary: AppColors.light.textLight,
        surface: AppColors.light.primaryLight,
        onSurface: AppColors.light.textPrimary,
        onSurfaceVariant: AppColors.light.greyMedium,
      ),
    ),

    colorScheme: ColorScheme.light(
      primary: AppColors.light.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.light.primaryLight,
      onPrimaryContainer: AppColors.light.textPrimary,
      surface: AppColors.light.cardBackground,
      onSurface: AppColors.light.textPrimary,
      onSurfaceVariant: AppColors.light.textSecondary,
    ),

    textTheme: AppTextTheme.textTheme(
      ColorScheme.light(
        primary: AppColors.light.primary,
        primaryContainer: AppColors.light.primaryLight,
        surface: AppColors.light.cardBackground,
        onPrimary: Colors.white,
        onSurface: AppColors.light.textPrimary,
        onSurfaceVariant: AppColors.light.textSecondary,
      ),
      lightExtension,
    ),
  );

  // DARK THEME

  static AppThemeExtension darkExtension = const AppThemeExtension(
    colors: AppColors.dark,
  );

  static ThemeData darkTheme = ThemeData(
    extensions: [darkExtension],
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark.background,

    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.dark.background,
    ),

    cardColor: AppColors.dark.cardBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.dark.primary),
    ),

    shadowColor: Colors.black,

    iconTheme: IconThemeData(color: AppColors.dark.primary),

    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.dark(
        primary: AppColors.dark.primary,
        onPrimary: AppColors.dark.textLight,
        secondary: AppColors.dark.background,
        onSecondary: AppColors.dark.textPrimary,
        tertiary: AppColors.dark.accent,
        onTertiary: AppColors.dark.textLight,
        surface: AppColors.dark.primaryLight,
        onSurface: AppColors.dark.textPrimary,
        onSurfaceVariant: AppColors.dark.greyMedium,
      ),
    ),

    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.dark.primaryLight,
      onPrimaryContainer: AppColors.dark.textPrimary,
      surface: AppColors.dark.cardBackground,
      onSurface: AppColors.dark.textPrimary,
      onSurfaceVariant: AppColors.dark.textSecondary,
    ),

    textTheme: AppTextTheme.textTheme(
      ColorScheme.dark(
        primary: AppColors.dark.primary,
        primaryContainer: AppColors.dark.primaryLight,
        surface: AppColors.dark.cardBackground,
        onPrimary: Colors.white,
        onSurface: AppColors.dark.textPrimary,
        onSurfaceVariant: AppColors.dark.textSecondary,
      ),
      darkExtension,
    ),
  );
}
