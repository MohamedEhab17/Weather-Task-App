import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';

import 'package:weather_task_app/core/theme/weather_theme_helper.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/core/widgets/custom_loading_indicator.dart';
import 'package:weather_task_app/features/weather_details/presentation/utils/sun_cycle_utils.dart';
import 'package:weather_task_app/features/weather_details/presentation/widgets/details_grid.dart';
import 'package:weather_task_app/features/weather_details/presentation/widgets/hourly_forecast_list.dart';
import 'package:weather_task_app/features/weather_details/presentation/widgets/sun_cycle_card.dart';

class WeatherDetailsView extends StatelessWidget {
  final WeatherEntity? weather;

  const WeatherDetailsView({super.key, this.weather});

  @override
  Widget build(BuildContext context) {
    final currentWeather = weather;
    if (currentWeather == null) {
      return const Scaffold(
        body: Center(
          child: CustomLoadingIndicator(),
        ),
      );
    }

    final settingsState = context.watch<SettingsCubit>().state;
    final isCelsius = settingsState.isCelsius;
    final isKmph = settingsState.isKmph;

    final sunProgress = SunCycleUtils.calculateSunProgress(
      currentWeather.sunrise,
      currentWeather.sunset,
      currentWeather.localTime,
    );
    final daylightHoursRemaining = SunCycleUtils.calculateDaylightRemaining(
      currentWeather.sunset,
      currentWeather.localTime,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundGradient = WeatherThemeHelper.getBackgroundGradient(
      currentWeather,
      context.ext.colors,
      isDark,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: context.ext.colors.textPrimary,
                        size: 20.sp,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Text(
                      currentWeather.locationName,
                      style: context.text.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Mini Dashboard
                      Center(
                        child: Column(
                          children: [
                            Text(
                              isCelsius
                                  ? '${currentWeather.tempC.round()}°'
                                  : '${currentWeather.tempF.round()}°',
                              style: TextStyle(
                                fontSize: 64.sp,
                                fontWeight: FontWeight.bold,
                                color: context.ext.colors.textPrimary,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              currentWeather.conditionText,
                              style: context.text.titleLarge!.copyWith(
                                color: context.ext.colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'H: ${currentWeather.forecastDays.isNotEmpty ? (isCelsius ? currentWeather.forecastDays.first.maxTempC.round() : currentWeather.forecastDays.first.maxTempF.round()) : 0}°  L: ${currentWeather.forecastDays.isNotEmpty ? (isCelsius ? currentWeather.forecastDays.first.minTempC.round() : currentWeather.forecastDays.first.minTempF.round()) : 0}°',
                              style: context.text.bodyMedium!.copyWith(
                                color: context.ext.colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Hourly Forecast Header & Horizontal List
                      Text(
                        context.trContext(TK.hourlyForecast),
                        style: context.text.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.ext.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      HourlyForecastList(
                        hours: currentWeather.hourlyForecast,
                        isCelsius: isCelsius,
                        localTimeStr: currentWeather.localTime,
                      ),
                      SizedBox(height: 28.h),

                      // Daily Details Grid Header & Grid
                      Text(
                        context.trContext(TK.dailyDetails),
                        style: context.text.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.ext.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      DetailsGrid(
                        weather: currentWeather,
                        isCelsius: isCelsius,
                        isKmph: isKmph,
                      ),
                      SizedBox(height: 28.h),

                      // Sun Cycle Header & Card
                      Text(
                        context.trContext(TK.sunCycle),
                        style: context.text.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.ext.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SunCycleCard(
                        weather: currentWeather,
                        progress: sunProgress,
                        hoursRemaining: daylightHoursRemaining,
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
