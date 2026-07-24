import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/routers/app_router_paths.dart';
import 'package:weather_task_app/core/widgets/custom_loading_indicator.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_state.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/floating_widget.dart';

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
          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().init(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 150.h),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    key: const ValueKey('error_widget'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: context.ext.colors.error,
                          size: 60.sp,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          state.message,
                          style: context.text.titleMedium!.copyWith(
                            color: context.ext.colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton.icon(
                          onPressed: () => context.read<DashboardCubit>().init(),
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(context.trContext(TK.done)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.ext.colors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
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
                  // Fake Search Bar
                  GestureDetector(
                    onTap: onSearchTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: context.ext.colors.cardBackground,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: context.ext.colors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: context.ext.colors.textSecondary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            context.trContext(TK.weatherSearchHint),
                            style: context.text.bodyMedium!.copyWith(
                              color: context.ext.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Location Details
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, val, child) {
                      return Opacity(
                        opacity: val,
                        child: Transform.translate(
                          offset: Offset(0, (1 - val) * 20),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          weather.locationName,
                          style: context.text.displayLarge!.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          _formatDate(weather.localTime, context.locale.languageCode),
                          style: context.text.titleLarge!.copyWith(
                            color: context.ext.colors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Weather Icon and Temp (Animated)
                  TweenAnimationBuilder<double>(
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
                        // Glassmorphic condition circle
                        // Extra vertical SizedBox gives the FloatingWidget's ±6px
                        // animation room so the icon never gets clipped by the circle.
                        SizedBox(
                          width: 160.w,
                          height: 180.w, // 160 circle + 20 float headroom
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

                        // Temperature
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
                  ),
                  SizedBox(height: 32.h),

                  // Main stats cards (humidity and wind speed)
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          icon: Icons.water_drop_outlined,
                          title: context.trContext(TK.weatherHumidity),
                          value: '${weather.humidity}%',
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildMetricCard(
                          context,
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

                  // 3-Day Forecast Section Header
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

                  // 3-Day Forecast Cards
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
                  // Bottom padding so the last card isn't hidden under the floating NavBar
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

  Widget _buildMetricCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: context.ext.colors.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.ext.colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.ext.colors.primaryLight,
            ),
            child: Icon(
              icon,
              color: context.ext.colors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: context.text.bodyMedium!.copyWith(
              color: context.ext.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: context.text.headlineSmall!.copyWith(
              color: context.ext.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr, String locale) {
    try {
      final inputFormat = DateFormat("yyyy-MM-dd HH:mm");
      final date = inputFormat.parse(dateStr);
      final outputFormat = DateFormat("EEEE, MMM dd", locale);
      return outputFormat.format(date);
    } catch (e) {
      return dateStr;
    }
  }

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
}
