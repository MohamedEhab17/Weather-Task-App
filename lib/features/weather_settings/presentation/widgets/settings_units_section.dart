import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';
import 'package:weather_task_app/features/weather_settings/presentation/widgets/settings_card.dart';
import 'package:weather_task_app/features/weather_settings/presentation/widgets/settings_section_header.dart';
import 'package:weather_task_app/features/weather_settings/presentation/widgets/settings_unit_option.dart';

class SettingsUnitsSection extends StatelessWidget {
  const SettingsUnitsSection({
    super.key,
    required this.isCelsius,
    required this.isKmph,
  });

  final bool isCelsius;
  final bool isKmph;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: context.trContext(TK.sectionUnits)),
        SizedBox(height: 12.h),

        SettingsCard(
          icon: Icons.thermostat_rounded,
          title: context.trContext(TK.unitsTemp),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingsUnitOption(
                label: '°C',
                isSelected: isCelsius,
                onTap: () {
                  if (!isCelsius) context.read<SettingsCubit>().toggleTempUnit();
                },
              ),
              SizedBox(width: 4.w),
              SettingsUnitOption(
                label: '°F',
                isSelected: !isCelsius,
                onTap: () {
                  if (isCelsius) context.read<SettingsCubit>().toggleTempUnit();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        SettingsCard(
          icon: Icons.air_rounded,
          title: context.trContext(TK.unitsWind),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingsUnitOption(
                label: 'km/h',
                isSelected: isKmph,
                onTap: () {
                  if (!isKmph) context.read<SettingsCubit>().toggleWindUnit();
                },
              ),
              SizedBox(width: 4.w),
              SettingsUnitOption(
                label: 'mph',
                isSelected: !isKmph,
                onTap: () {
                  if (isKmph) context.read<SettingsCubit>().toggleWindUnit();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
