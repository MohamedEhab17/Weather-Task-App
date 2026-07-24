import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

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

    int currentHour = 12;
    try {
      final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(widget.localTimeStr);
      currentHour = dateTime.hour;
    } catch (_) {}

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_activeHourIndex > 0 && _scrollController.hasClients) {
        final targetOffset = _activeHourIndex * (72.w + 12.w);
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

  String _formatHour(String timeStr, String locale) {
    try {
      final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(timeStr);
      return DateFormat("h a", locale).format(dateTime);
    } catch (_) {
      return timeStr;
    }
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
}
