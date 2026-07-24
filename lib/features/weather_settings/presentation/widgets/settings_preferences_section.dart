import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/localization/cubit/language_cubit.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/theme/cubit/theme_cubit.dart';
import 'package:weather_task_app/features/weather_settings/presentation/widgets/settings_card.dart';
import 'package:weather_task_app/features/weather_settings/presentation/widgets/settings_section_header.dart';
import 'package:weather_task_app/features/weather_settings/presentation/widgets/settings_unit_option.dart';

class SettingsPreferencesSection extends StatelessWidget {
  const SettingsPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: context.trContext(TK.sectionPreferences)),
        SizedBox(height: 12.h),

        BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, themeMode) {
            final isDark = themeMode == AppThemeMode.dark;
            return SettingsCard(
              icon: Icons.brightness_6_rounded,
              title: context.trContext(TK.appearance),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingsUnitOption(
                    label: context.trContext(TK.appearanceLight),
                    isSelected: !isDark,
                    onTap: () {
                      if (isDark) context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                  SizedBox(width: 4.w),
                  SettingsUnitOption(
                    label: context.trContext(TK.appearanceDark),
                    isSelected: isDark,
                    onTap: () {
                      if (!isDark) context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 16.h),

        BlocBuilder<LanguageCubit, Locale>(
          builder: (context, currentLocale) {
            final isEnglish = currentLocale.languageCode == 'en';
            return SettingsCard(
              icon: Icons.language_rounded,
              title: context.trContext(TK.weatherLanguage),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingsUnitOption(
                    label: 'English',
                    isSelected: isEnglish,
                    onTap: () async {
                      if (!isEnglish) {
                        await context.read<LanguageCubit>().changeLanguage('en');
                        if (context.mounted) {
                          context.setLocale(const Locale('en'));
                        }
                      }
                    },
                  ),
                  SizedBox(width: 4.w),
                  SettingsUnitOption(
                    label: 'العربية',
                    isSelected: !isEnglish,
                    onTap: () async {
                      if (isEnglish) {
                        await context.read<LanguageCubit>().changeLanguage('ar');
                        if (context.mounted) {
                          context.setLocale(const Locale('ar'));
                        }
                      }
                    },
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
