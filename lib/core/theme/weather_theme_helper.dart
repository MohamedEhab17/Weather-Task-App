import 'package:flutter/material.dart';
import 'package:weather_task_app/core/theme/app_colors.dart';
import 'package:weather_task_app/core/theme/weather_background_gradients.dart';
import 'package:weather_task_app/core/theme/weather_card_gradients.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

class WeatherThemeHelper {
  WeatherThemeHelper._();

  static LinearGradient getBackgroundGradient(WeatherEntity? weather, AppColors colors, bool isDark) {
    return WeatherBackgroundGradients.getBackgroundGradient(weather, colors, isDark);
  }

  static LinearGradient getCardGradient(WeatherEntity? weather, bool isDark) {
    return WeatherCardGradients.getCardGradient(weather, isDark);
  }
}
