import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_details/presentation/widgets/sun_cycle_painter.dart';

class SunCycleCard extends StatelessWidget {
  const SunCycleCard({
    super.key,
    required this.weather,
    required this.progress,
    required this.hoursRemaining,
  });

  final WeatherEntity weather;
  final double progress;
  final double hoursRemaining;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    if (isTablet) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.ext.colors.cardBackground,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: context.ext.colors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_twilight_rounded, color: Colors.amber, size: 28.sp),
                  SizedBox(height: 8.h),
                  Text(
                    context.trContext(TK.sunrise),
                    style: context.text.bodyMedium!.copyWith(
                      color: context.ext.colors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    weather.sunrise,
                    style: context.text.titleMedium!.copyWith(
                      color: context.ext.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: progress),
                      duration: const Duration(milliseconds: 1600),
                      curve: Curves.easeOutCubic,
                      builder: (context, val, child) {
                        return CustomPaint(
                          painter: SunCyclePainter(
                            progress: val,
                            lineColor: context.ext.colors.primary,
                            greyColor: context.ext.colors.greyLight,
                          ),
                        );
                      },
                    ),
                  ),
                  if (progress > 0.0 && progress < 1.0) ...[
                    SizedBox(height: 8.h),
                    Text(
                      '${hoursRemaining.toStringAsFixed(1)} ${context.trContext(TK.daylightRemaining)}',
                      style: context.text.bodyMedium!.copyWith(
                        color: context.ext.colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(
              width: 80.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.nights_stay_rounded, color: Colors.indigoAccent, size: 28.sp),
                  SizedBox(height: 8.h),
                  Text(
                    context.trContext(TK.sunset),
                    style: context.text.bodyMedium!.copyWith(
                      color: context.ext.colors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    weather.sunset,
                    style: context.text.titleMedium!.copyWith(
                      color: context.ext.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.ext.colors.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.ext.colors.cardBorder),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160.h,
            width: double.infinity,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 1600),
              curve: Curves.easeOutCubic,
              builder: (context, val, child) {
                return CustomPaint(
                  painter: SunCyclePainter(
                    progress: val,
                    lineColor: context.ext.colors.primary,
                    greyColor: context.ext.colors.greyLight,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trContext(TK.sunrise),
                    style: context.text.bodySmall!.copyWith(
                      color: context.ext.colors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    weather.sunrise,
                    style: context.text.titleMedium!.copyWith(
                      color: context.ext.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    context.trContext(TK.sunset),
                    style: context.text.bodySmall!.copyWith(
                      color: context.ext.colors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    weather.sunset,
                    style: context.text.titleMedium!.copyWith(
                      color: context.ext.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (progress > 0.0 && progress < 1.0) ...[
            const Divider(height: 24, thickness: 0.8),
            Text(
              '${hoursRemaining.toStringAsFixed(1)} ${context.trContext(TK.daylightRemaining)}',
              style: context.text.bodyMedium!.copyWith(
                color: context.ext.colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
