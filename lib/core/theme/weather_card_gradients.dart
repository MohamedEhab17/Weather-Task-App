import 'package:flutter/material.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

class WeatherCardGradients {
  WeatherCardGradients._();

  static LinearGradient getCardGradient(WeatherEntity? weather, bool isDark) {
    if (isDark) {
      if (weather == null) {
        return LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.12), Colors.white.withValues(alpha: 0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }

      if (!weather.isDay) {
        return LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.10),
            Colors.white.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }

      return LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.15),
          Colors.white.withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      if (weather == null) {
        return LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.85), Colors.white.withValues(alpha: 0.70)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }

      if (!weather.isDay) {
        return LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.80),
            Colors.white.withValues(alpha: 0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }

      return LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.90),
          Colors.white.withValues(alpha: 0.75),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
}
