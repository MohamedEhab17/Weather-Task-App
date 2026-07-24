import 'package:flutter/material.dart';
import 'package:weather_task_app/core/theme/app_dark_theme.dart';
import 'package:weather_task_app/core/theme/app_light_theme.dart';
import 'package:weather_task_app/core/theme/app_theme_extension.dart';

class AppTheme {
  static AppThemeExtension get lightExtension => AppLightTheme.extension;
  static ThemeData get lightTheme => AppLightTheme.theme;

  static AppThemeExtension get darkExtension => AppDarkTheme.extension;
  static ThemeData get darkTheme => AppDarkTheme.theme;
}
