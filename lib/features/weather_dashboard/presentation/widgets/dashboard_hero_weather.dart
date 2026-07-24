import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/floating_widget.dart';

class DashboardHeroWeather extends StatelessWidget {
  const DashboardHeroWeather({
    super.key,
    required this.weather,
    required this.isCelsius,
  });

  final WeatherEntity weather;
  final bool isCelsius;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Column(
        children: [
          SizedBox(
            width: 160.w,
            height: 180.w,
            child: Center(
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.ext.colors.cardBackground,
                  border: Border.all(color: context.ext.colors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: context.ext.colors.accent.withValues(alpha: 0.15),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: FloatingWidget(
                    child: Image.network(
                      'https:${weather.conditionIcon}',
                      width: 110.w,
                      height: 110.w,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.wb_sunny_rounded,
                        size: 80.sp,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            isCelsius
                ? '${weather.tempC.round()}°C'
                : '${weather.tempF.round()}°F',
            style: TextStyle(
              fontSize: 72.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: context.ext.colors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            weather.conditionText,
            style: context.text.displayMedium!.copyWith(
              color: context.ext.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
