import 'package:flutter/material.dart';
import 'package:weather_task_app/core/theme/app_colors.dart';
import 'package:weather_task_app/core/theme/app_text_theme.dart';
import 'package:weather_task_app/core/theme/app_theme_extension.dart';

class AppLightTheme {
  AppLightTheme._();

  static AppThemeExtension extension = const AppThemeExtension(
    colors: AppColors.light,
  );

  static ThemeData get theme => ThemeData(
    extensions: [extension],
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
      extension,
    ),
  );
}
