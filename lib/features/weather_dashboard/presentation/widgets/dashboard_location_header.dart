import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';

class DashboardLocationHeader extends StatelessWidget {
  const DashboardLocationHeader({
    super.key,
    required this.locationName,
    required this.localTime,
  });

  final String locationName;
  final String localTime;

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

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
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
            locationName,
            style: context.text.displayLarge!.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            _formatDate(localTime, context.locale.languageCode),
            style: context.text.titleLarge!.copyWith(
              color: context.ext.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
