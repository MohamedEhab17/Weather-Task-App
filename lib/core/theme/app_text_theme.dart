import 'package:flutter/material.dart';
import 'package:weather_task_app/core/utils/app_styles.dart';

import 'app_theme_extension.dart';

class AppTextTheme {
  static TextTheme textTheme(ColorScheme colorScheme, AppThemeExtension ext) {
    return TextTheme(
      displayLarge: AppStyles.styleInter32.copyWith(
        color: ext.colors.textPrimary,
      ),
      displayMedium: AppStyles.styleInter24.copyWith(
        color: ext.colors.textPrimary,
      ),
      displaySmall: AppStyles.styleRoboto24.copyWith(
        color: ext.colors.textPrimary,
      ),

      headlineLarge: AppStyles.styleScriptMT32.copyWith(
        color: ext.colors.primaryDark,
      ),
      headlineMedium: AppStyles.styleRoboto20.copyWith(
        color: ext.colors.textSecondary,
      ),
      headlineSmall: AppStyles.styleInter20.copyWith(
        color: ext.colors.textPrimary,
      ),
      
      titleLarge: AppStyles.styleRoboto16.copyWith(
        color: ext.colors.textSecondary,
      ),
      titleMedium: AppStyles.styleInter16.copyWith(
        color: ext.colors.textPrimary,
      ),
      titleSmall: AppStyles.styleInter14.copyWith(
        color: ext.colors.textPrimary.withAlpha(178),
      ),

      bodyLarge: AppStyles.styleRoboto12.copyWith(
        color: ext.colors.textSecondary,
      ),
      bodyMedium: AppStyles.styleInter12.copyWith(
        color: ext.colors.textPrimary,
      ),
      bodySmall: AppStyles.styleInter10.copyWith(
        color: ext.colors.textPrimary,
      ),

      labelSmall: AppStyles.styleInter8.copyWith(
        color: ext.colors.textSecondary,
      ),
    );
  }
}
