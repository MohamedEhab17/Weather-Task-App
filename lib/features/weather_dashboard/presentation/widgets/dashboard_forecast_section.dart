import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/routers/app_router_paths.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

class DashboardForecastSection extends StatelessWidget {
  const DashboardForecastSection({
    super.key,
    required this.weather,
    required this.isCelsius,
  });

  final WeatherEntity weather;
  final bool isCelsius;

  String _getDayName(String dateStr, String locale, int index) {
    if (index == 0) {
      return locale == 'ar' ? 'اليوم' : 'Today';
    }
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE', locale).format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.trContext(TK.weatherForecast),
              style: context.text.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRoutesPaths.details, extra: weather),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.trContext(TK.viewAll),
                    style: context.text.bodyMedium!.copyWith(
                      color: context.ext.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18.sp,
                    color: context.ext.colors.textPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weather.forecastDays.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final day = weather.forecastDays[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: context.ext.colors.cardBackground,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: context.ext.colors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      _getDayName(day.date, context.locale.languageCode, index),
                      style: context.text.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Image.network(
                          'https:${day.conditionIcon}',
                          width: 32.w,
                          height: 32.w,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            day.conditionText,
                            style: context.text.bodyMedium!.copyWith(
                              color: context.ext.colors.textSecondary,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      isCelsius
                          ? '${day.maxTempC.round()}° / ${day.minTempC.round()}°'
                          : '${day.maxTempF.round()}° / ${day.minTempF.round()}°',
                      style: context.text.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
