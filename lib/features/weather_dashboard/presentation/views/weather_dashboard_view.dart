import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';
import 'package:weather_task_app/core/widgets/custom_loading_indicator.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_state.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/dashboard_error_view.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/dashboard_forecast_section.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/dashboard_hero_weather.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/dashboard_location_header.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/dashboard_metric_card.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/dashboard_search_bar.dart';

class WeatherDashboardView extends StatelessWidget {
  final VoidCallback onSearchTap;

  const WeatherDashboardView({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isCelsius = settingsState.isCelsius;
    final isKmph = settingsState.isKmph;

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const Center(child: CustomLoadingIndicator());
        } else if (state is DashboardError) {
          return DashboardErrorView(message: state.message);
        } else if (state is DashboardSuccess) {
          final weather = state.weather;
          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().fetchWeatherForCity(weather.locationName),
            color: context.ext.colors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),

                  // Search bar
                  DashboardSearchBar(onSearchTap: onSearchTap),
                  SizedBox(height: 32.h),

                  // Location header
                  DashboardLocationHeader(
                    locationName: weather.locationName,
                    localTime: weather.localTime,
                  ),
                  SizedBox(height: 24.h),

                  // Hero weather (Condition circle, temperature, text)
                  DashboardHeroWeather(
                    weather: weather,
                    isCelsius: isCelsius,
                  ),
                  SizedBox(height: 32.h),

                  // Main stats cards (humidity and wind speed)
                  Row(
                    children: [
                      Expanded(
                        child: DashboardMetricCard(
                          icon: Icons.water_drop_outlined,
                          title: context.trContext(TK.weatherHumidity),
                          value: '${weather.humidity}%',
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: DashboardMetricCard(
                          icon: Icons.air_rounded,
                          title: context.trContext(TK.weatherWind),
                          value: isKmph
                              ? '${weather.windKph.round()} km/h'
                              : '${weather.windMph.round()} mph',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // 3-Day Forecast Section
                  DashboardForecastSection(
                    weather: weather,
                    isCelsius: isCelsius,
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
