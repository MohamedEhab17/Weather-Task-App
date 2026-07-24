import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';

class SettingsAppInfo extends StatelessWidget {
  const SettingsAppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'WEATHER TASK APP',
            style: context.text.titleMedium!.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            context.trContext(TK.version),
            style: context.text.labelSmall!.copyWith(
              color: context.ext.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            context.trContext(TK.companyBio),
            style: context.text.labelSmall!.copyWith(
              color: context.ext.colors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.trContext(TK.privacyPolicy),
                style: context.text.labelSmall!.copyWith(
                  color: context.ext.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(width: 24.w),
              Text(
                context.trContext(TK.termsOfService),
                style: context.text.labelSmall!.copyWith(
                  color: context.ext.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
