import 'package:flutter/material.dart';
import 'package:weather_task_app/core/theme/app_colors.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

class WeatherBackgroundGradients {
  WeatherBackgroundGradients._();

  static LinearGradient getBackgroundGradient(WeatherEntity? weather, AppColors colors, bool isDark) {
    if (weather == null) {
      return LinearGradient(
        colors: [colors.background, colors.backgroundGradientEnd],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    if (isDark) {
      if (!weather.isDay) {
        return const LinearGradient(
          colors: [
            Color(0xFF060919),
            Color(0xFF0E162F),
            Color(0xFF182348),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      }

      final cond = weather.conditionText.toLowerCase();

      if (cond.contains('rain') || cond.contains('drizzle') || cond.contains('shower') || cond.contains('thunder')) {
        return const LinearGradient(
          colors: [
            Color(0xFF2C3A47),
            Color(0xFF435368),
            Color(0xFF5E728C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      }

      if (cond.contains('cloud') || cond.contains('overcast') || cond.contains('mist') || cond.contains('fog')) {
        return const LinearGradient(
          colors: [
            Color(0xFF3A4B5C),
            Color(0xFF5B6E82),
            Color(0xFF7A8FA5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      }

      return const LinearGradient(
        colors: [
          Color(0xFF1852B4),
          Color(0xFF357FE0),
          Color(0xFF5AA4FF),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      if (!weather.isDay) {
        return const LinearGradient(
          colors: [
            Color(0xFFE6E8F3),
            Color(0xFFD0D4EE),
            Color(0xFFD6C8F3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      }

      final cond = weather.conditionText.toLowerCase();

      if (cond.contains('rain') || cond.contains('drizzle') || cond.contains('shower') || cond.contains('thunder')) {
        return const LinearGradient(
          colors: [
            Color(0xFFBDC7D0),
            Color(0xFF9FAAB5),
            Color(0xFF8A97A3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      }

      if (cond.contains('cloud') || cond.contains('overcast') || cond.contains('mist') || cond.contains('fog')) {
        return const LinearGradient(
          colors: [
            Color(0xFFE4E8EB),
            Color(0xFFCAD0D4),
            Color(0xFFB5BDC2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      }

      return const LinearGradient(
        colors: [
          Color(0xFFBBE6FF),
          Color(0xFFD9EEFD),
          Color(0xFFFFF7C2),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }
}
