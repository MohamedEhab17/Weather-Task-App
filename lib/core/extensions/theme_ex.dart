import 'package:flutter/material.dart';
import 'package:weather_task_app/core/theme/app_theme_extension.dart';
import 'package:weather_task_app/core/extensions/string_ex.dart';

extension ThemeEx on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;
  AppThemeExtension get ext => theme.extension<AppThemeExtension>()!;
}

extension TextStyleArabicEx on TextStyle {
  TextStyle forText(String text) {
    if (text.isArabic) {
      return copyWith(
        fontFamily: null,
        height: 1.4,
        letterSpacing: 0,
      );
    }
    return this;
  }
}

