import 'package:flutter/material.dart';
import 'package:weather_task_app/core/theme/app_colors.dart';
import 'package:weather_task_app/core/theme/app_text_theme.dart';
import 'package:weather_task_app/core/theme/app_theme_extension.dart';

class AppDarkTheme {
  AppDarkTheme._();

  static AppThemeExtension extension = const AppThemeExtension(
    colors: AppColors.dark,
  );

  static ThemeData get theme => ThemeData(
    extensions: [extension],
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
      extension,
    ),
  );
}
