import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';
import 'package:weather_task_app/core/settings/cubit/settings_state.dart';
import 'package:weather_task_app/features/weather_settings/presentation/widgets/settings_app_info.dart';
import 'package:weather_task_app/features/weather_settings/presentation/widgets/settings_preferences_section.dart';
import 'package:weather_task_app/features/weather_settings/presentation/widgets/settings_units_section.dart';

class WeatherSettingsView extends StatelessWidget {
  const WeatherSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final bool isCelsius = state.isCelsius;
        final bool isKmph = state.isKmph;

        return Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  context.trContext(TK.weatherSettings),
                  style: context.text.displayLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  context.trContext(TK.settingsSubtitle),
                  style: context.text.bodyMedium!.copyWith(
                    color: context.ext.colors.textSecondary,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 1: Units & Formatting
                SettingsUnitsSection(
                  isCelsius: isCelsius,
                  isKmph: isKmph,
                ),
                SizedBox(height: 32.h),

                // Section 2: Preferences (Theme & Language)
                const SettingsPreferencesSection(),
                SizedBox(height: 48.h),

                // Section 3: App Info
                const SettingsAppInfo(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
