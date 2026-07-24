import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_details/presentation/widgets/details_card.dart';

class DetailsGrid extends StatelessWidget {
  const DetailsGrid({
    super.key,
    required this.weather,
    required this.isCelsius,
    required this.isKmph,
  });

  final WeatherEntity weather;
  final bool isCelsius;
  final bool isKmph;

  Color _getUvColor(double uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.amber;
    if (uv <= 7) return Colors.orange;
    return Colors.red;
  }

  String _getUvDescription(double uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 3 : 2,
      childAspectRatio: isTablet ? 1.35 : 1.15,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      children: [
        DetailsCard(
          icon: Icons.water_drop_outlined,
          title: context.trContext(TK.weatherHumidity),
          value: '${weather.humidity}%',
          desc: 'Feels like ${isCelsius ? weather.feelsLikeC.round() : weather.feelsLikeF.round()}°',
        ),
        DetailsCard(
          icon: Icons.air_rounded,
          title: context.trContext(TK.weatherWind),
          value: isKmph ? '${weather.windKph.round()} km/h' : '${weather.windMph.round()} mph',
          desc: 'Direction: ${weather.windDir}',
        ),
        DetailsCard(
          icon: Icons.wb_sunny_outlined,
          title: context.trContext(TK.uvIndex),
          value: '${weather.uv.round()}',
          desc: _getUvDescription(weather.uv),
          footer: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: weather.uv / 12.0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, val, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: LinearProgressIndicator(
                  value: val,
                  backgroundColor: context.ext.colors.greyExtraLight.withValues(alpha: 0.5),
                  color: _getUvColor(weather.uv),
                  minHeight: 4.h,
                ),
              );
            },
          ),
        ),
        DetailsCard(
          icon: Icons.visibility_outlined,
          title: context.trContext(TK.visibility),
          value: isKmph ? '${weather.visKm.round()} km' : '${weather.visMiles.round()} mi',
          desc: weather.visKm >= 10 ? 'Perfect clarity' : 'Slight haze',
        ),
        DetailsCard(
          icon: Icons.compress_rounded,
          title: context.trContext(TK.pressure),
          value: '${weather.pressureMb.round()} hPa',
          desc: weather.pressureMb > 1013 ? 'Higher than standard' : 'Lower than standard',
        ),
        DetailsCard(
          icon: Icons.thermostat_rounded,
          title: context.trContext(TK.feelsLike),
          value: isCelsius ? '${weather.feelsLikeC.round()}°C' : '${weather.feelsLikeF.round()}°F',
          desc: 'Wind chill is ${isCelsius ? weather.tempC.round() : weather.tempF.round()}°',
        ),
      ],
    );
  }
}
