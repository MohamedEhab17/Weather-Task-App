import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/widgets/custom_loading_indicator.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';
import 'package:weather_task_app/core/theme/weather_theme_helper.dart';

class WeatherDetailsView extends StatelessWidget {
  final WeatherEntity? weather;

  const WeatherDetailsView({super.key, this.weather});

  @override
  Widget build(BuildContext context) {
    final currentWeather = this.weather;
    if (currentWeather == null) {
      return Scaffold(
        body: Center(
          child: CustomLoadingIndicator(),
        ),
      );
    }

    final settingsState = context.watch<SettingsCubit>().state;
    final isCelsius = settingsState.isCelsius;
    final isKmph = settingsState.isKmph;

    // Calculate sun cycle progress
    final sunProgress = _calculateSunProgress(currentWeather.sunrise, currentWeather.sunset, currentWeather.localTime);
    final daylightHoursRemaining = _calculateDaylightRemaining(currentWeather.sunset, currentWeather.localTime);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundGradient = WeatherThemeHelper.getBackgroundGradient(currentWeather, context.ext.colors, isDark);

    final weather = currentWeather;

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
                      weather.locationName,
                      style: context.text.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer to balance back arrow
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
                                  ? '${weather.tempC.round()}°'
                                  : '${weather.tempF.round()}°',
                              style: TextStyle(
                                fontSize: 64.sp,
                                fontWeight: FontWeight.bold,
                                color: context.ext.colors.textPrimary,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              weather.conditionText,
                              style: context.text.titleLarge!.copyWith(
                                color: context.ext.colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'H: ${weather.forecastDays.isNotEmpty ? (isCelsius ? weather.forecastDays.first.maxTempC.round() : weather.forecastDays.first.maxTempF.round()) : 0}°  L: ${weather.forecastDays.isNotEmpty ? (isCelsius ? weather.forecastDays.first.minTempC.round() : weather.forecastDays.first.minTempF.round()) : 0}°',
                              style: context.text.bodyMedium!.copyWith(
                                color: context.ext.colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Hourly Forecast
                      Text(
                        context.trContext(TK.hourlyForecast),
                        style: context.text.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.ext.colors.textPrimary),
                      ),
                      SizedBox(height: 12.h),
                      // Hourly horizontal list
                      HourlyForecastList(
                        hours: weather.hourlyForecast,
                        isCelsius: isCelsius,
                        localTimeStr: weather.localTime,
                      ),
                      SizedBox(height: 28.h),

                      // Daily Details Grid Header
                      Text(
                        context.trContext(TK.dailyDetails),
                        style: context.text.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.ext.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // 2x3 Grid of weather details
                      _buildDetailsGrid(context, weather, isCelsius, isKmph),
                      SizedBox(height: 28.h),

                      // Sun Cycle Widget
                      Text(
                        context.trContext(TK.sunCycle),
                        style: context.text.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.ext.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildSunCycleCard(context, weather, sunProgress, daylightHoursRemaining),
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

class HourlyForecastList extends StatefulWidget {
  final List<HourlyForecastEntity> hours;
  final bool isCelsius;
  final String localTimeStr;

  const HourlyForecastList({
    super.key,
    required this.hours,
    required this.isCelsius,
    required this.localTimeStr,
  });

  @override
  State<HourlyForecastList> createState() => _HourlyForecastListState();
}

class _HourlyForecastListState extends State<HourlyForecastList> {
  late final ScrollController _scrollController;
  int _activeHourIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Parse current hour to highlight it
    int currentHour = 12;
    try {
      final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(widget.localTimeStr);
      currentHour = dateTime.hour;
    } catch (_) {}

    // Find active hour index
    for (int i = 0; i < widget.hours.length; i++) {
      int hourVal = 0;
      try {
        final hourTime = DateFormat("yyyy-MM-dd HH:mm").parse(widget.hours[i].time);
        hourVal = hourTime.hour;
      } catch (_) {}
      if (hourVal == currentHour) {
        _activeHourIndex = i;
        break;
      }
    }

    // Auto scroll to active hour index on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_activeHourIndex > 0 && _scrollController.hasClients) {
        // Item width is 72.w, separator width is 12.w
        final targetOffset = _activeHourIndex * (72.w + 12.w);

        // Ensure we don't scroll past maxScrollExtent
        final maxScroll = _scrollController.position.maxScrollExtent;
        final finalOffset = targetOffset.clamp(0.0, maxScroll);

        _scrollController.animateTo(
          finalOffset,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.hours.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final hour = widget.hours[index];
          final isCurrent = index == _activeHourIndex;

          return Container(
            width: 72.w,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: isCurrent ? context.ext.colors.primary : context.ext.colors.cardBackground,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isCurrent ? Colors.transparent : context.ext.colors.cardBorder,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: context.ext.colors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatHour(hour.time, context.locale.languageCode),
                  style: context.text.bodySmall!.copyWith(
                    color: isCurrent ? Colors.white : context.ext.colors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.network(
                  'https:${hour.conditionIcon}',
                  width: 32.w,
                  height: 32.w,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
                Text(
                  widget.isCelsius ? '${hour.tempC.round()}°' : '${hour.tempF.round()}°',
                  style: context.text.bodyMedium!.copyWith(
                    color: isCurrent ? Colors.white : context.ext.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatHour(String timeStr, String locale) {
    try {
      final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(timeStr);
      return DateFormat("h a", locale).format(dateTime);
    } catch (_) {
      return timeStr;
    }
  }
}

Widget _buildDetailsGrid(BuildContext context, WeatherEntity weather, bool isCelsius, bool isKmph) {
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
      // Humidity
      _buildDetailCard(
        context,
        icon: Icons.water_drop_outlined,
        title: context.trContext(TK.weatherHumidity),
        value: '${weather.humidity}%',
        desc: 'Feels like ${isCelsius ? weather.feelsLikeC.round() : weather.feelsLikeF.round()}°',
      ),
      // Wind
      _buildDetailCard(
        context,
        icon: Icons.air_rounded,
        title: context.trContext(TK.weatherWind),
        value: isKmph ? '${weather.windKph.round()} km/h' : '${weather.windMph.round()} mph',
        desc: 'Direction: ${weather.windDir}',
      ),
      // UV Index
      _buildDetailCard(
        context,
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
      // Visibility
      _buildDetailCard(
        context,
        icon: Icons.visibility_outlined,
        title: context.trContext(TK.visibility),
        value: isKmph ? '${weather.visKm.round()} km' : '${weather.visMiles.round()} mi',
        desc: weather.visKm >= 10 ? 'Perfect clarity' : 'Slight haze',
      ),
      // Pressure
      _buildDetailCard(
        context,
        icon: Icons.compress_rounded,
        title: context.trContext(TK.pressure),
        value: '${weather.pressureMb.round()} hPa',
        desc: weather.pressureMb > 1013 ? 'Higher than standard' : 'Lower than standard',
      ),
      // Feels Like
      _buildDetailCard(
        context,
        icon: Icons.thermostat_rounded,
        title: context.trContext(TK.feelsLike),
        value: isCelsius ? '${weather.feelsLikeC.round()}°C' : '${weather.feelsLikeF.round()}°F',
        desc: 'Wind chill is ${isCelsius ? weather.tempC.round() : weather.tempF.round()}°',
      ),
    ],
  );
}

Widget _buildDetailCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String value,
  required String desc,
  Widget? footer,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: context.ext.colors.cardBackground,
      borderRadius: BorderRadius.circular(24.r),
      border: Border.all(color: context.ext.colors.cardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: context.ext.colors.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                title,
                style: context.text.bodyMedium!.copyWith(
                  color: context.ext.colors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: context.text.headlineSmall!.copyWith(
                fontWeight: FontWeight.w800,
                color: context.ext.colors.textPrimary,
              ),
            ),
            if (footer != null) ...[
              SizedBox(height: 4.h),
              footer,
            ],
            SizedBox(height: 2.h),
            Text(
              desc,
              style: context.text.labelSmall!.copyWith(
                color: context.ext.colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSunCycleCard(
  BuildContext context,
  WeatherEntity weather,
  double progress,
  double hoursRemaining,
) {
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
          // Sunrise Info
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

          // Arc & Daylight Remaining in Center — uses Expanded to prevent overflow
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

          // Sunset Info
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
        // Semi-circular Arc Painter
        // Height = radius + extra headroom so the arc top isn't clipped
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

        // Sunrise and Sunset Times Row
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

double _calculateSunProgress(String sunriseStr, String sunsetStr, String currentTimeStr) {
  try {
    final sunriseMins = _timeToMinutes(sunriseStr);
    final sunsetMins = _timeToMinutes(sunsetStr);

    final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(currentTimeStr);
    final currentMins = dateTime.hour * 60 + dateTime.minute;

    if (currentMins < sunriseMins) return 0.0;
    if (currentMins > sunsetMins) return 1.0;

    return (currentMins - sunriseMins) / (sunsetMins - sunriseMins);
  } catch (_) {
    return 0.5; // fallback
  }
}

double _calculateDaylightRemaining(String sunsetStr, String currentTimeStr) {
  try {
    final sunsetMins = _timeToMinutes(sunsetStr);
    final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(currentTimeStr);
    final currentMins = dateTime.hour * 60 + dateTime.minute;

    if (currentMins >= sunsetMins) return 0.0;
    return (sunsetMins - currentMins) / 60.0;
  } catch (_) {
    return 0.0;
  }
}

int _timeToMinutes(String timeStr) {
  // Example: "06:14 AM" or "08:22 PM"
  final parts = timeStr.split(' ');
  final hm = parts[0].split(':');
  int hours = int.parse(hm[0]);
  final minutes = int.parse(hm[1]);
  final ampm = parts[1].toUpperCase();

  if (ampm == 'PM' && hours < 12) {
    hours += 12;
  } else if (ampm == 'AM' && hours == 12) {
    hours = 0;
  }
  return hours * 60 + minutes;
}

class SunCyclePainter extends CustomPainter {
  final double progress;
  final Color lineColor;
  final Color greyColor;

  SunCyclePainter({
    required this.progress,
    required this.lineColor,
    required this.greyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Center is at the bottom of the canvas — semicircle rises upward.
    // We leave topPadding so the arc peak and sun glow never touch y=0.
    const double topPadding = 20.0;
    final center = Offset(size.width / 2, size.height);
    // Radius = available height minus the top padding so the arc fits fully.
    final radius = math.min(size.height - topPadding, size.width / 2.2);

    // Draw Arc
    final arcPaint = Paint()
      ..color = greyColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, math.pi, math.pi, false, arcPaint);

    // Draw Daylight Arc path completed
    final completedPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawArc(rect, math.pi, math.pi * progress, false, completedPaint);

    // Draw Sun position
    final sunAngle = math.pi + (math.pi * progress);
    final sunX = center.dx + radius * math.cos(sunAngle);
    final sunY = center.dy + radius * math.sin(sunAngle);

    final sunPaintOuter = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
      
    final sunPaintInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw outer glow and inner sun
    canvas.drawCircle(Offset(sunX, sunY), 12.r, Paint()..color = Colors.amber.withValues(alpha: 0.3)..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(sunX, sunY), 7.r, sunPaintOuter);
    canvas.drawCircle(Offset(sunX, sunY), 4.r, sunPaintInner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
