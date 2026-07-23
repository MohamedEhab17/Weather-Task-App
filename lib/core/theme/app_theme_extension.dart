import 'package:flutter/material.dart';
import 'package:weather_task_app/core/theme/app_colors.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final AppColors colors;

  const AppThemeExtension({required this.colors});

  @override
  AppThemeExtension copyWith({AppColors? colors}) {
    return AppThemeExtension(colors: colors ?? this.colors);
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(colors: colors);
  }
}
