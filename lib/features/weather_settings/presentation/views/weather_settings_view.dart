import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/localization/cubit/language_cubit.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/theme/cubit/theme_cubit.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';
import 'package:weather_task_app/core/settings/cubit/settings_state.dart';

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
            // Extra bottom padding so the privacy policy row stays above the NavBar
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
                _buildSectionHeader(context, context.trContext(TK.sectionUnits)),
                SizedBox(height: 12.h),

                // Temperature Unit setting card
                _buildSettingCard(
                  context,
                  icon: Icons.thermostat_rounded,
                  title: context.trContext(TK.unitsTemp),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildUnitOption(
                        context,
                        label: '°C',
                        isSelected: isCelsius,
                        onTap: () {
                          if (!isCelsius) context.read<SettingsCubit>().toggleTempUnit();
                        },
                      ),
                      SizedBox(width: 4.w),
                      _buildUnitOption(
                        context,
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

                // Wind Unit setting card
                _buildSettingCard(
                  context,
                  icon: Icons.air_rounded,
                  title: context.trContext(TK.unitsWind),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildUnitOption(
                        context,
                        label: 'km/h',
                        isSelected: isKmph,
                        onTap: () {
                          if (!isKmph) context.read<SettingsCubit>().toggleWindUnit();
                        },
                      ),
                      SizedBox(width: 4.w),
                      _buildUnitOption(
                        context,
                        label: 'mph',
                        isSelected: !isKmph,
                        onTap: () {
                          if (isKmph) context.read<SettingsCubit>().toggleWindUnit();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 2: Preferences
                _buildSectionHeader(context, context.trContext(TK.sectionPreferences)),
                SizedBox(height: 12.h),

                // Appearance Toggle Card
                BlocBuilder<ThemeCubit, AppThemeMode>(
                  builder: (context, themeMode) {
                    final isDark = themeMode == AppThemeMode.dark;
                    return _buildSettingCard(
                      context,
                      icon: Icons.brightness_6_rounded,
                      title: context.trContext(TK.appearance),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildUnitOption(
                            context,
                            label: context.trContext(TK.appearanceLight),
                            isSelected: !isDark,
                            onTap: () {
                              if (isDark) context.read<ThemeCubit>().toggleTheme();
                            },
                          ),
                          SizedBox(width: 4.w),
                          _buildUnitOption(
                            context,
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

                // Language Selector Card
                BlocBuilder<LanguageCubit, Locale>(
                  builder: (context, currentLocale) {
                    final isEnglish = currentLocale.languageCode == 'en';
                    return _buildSettingCard(
                      context,
                      icon: Icons.language_rounded,
                      title: context.trContext(TK.weatherLanguage),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildUnitOption(
                            context,
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
                          _buildUnitOption(
                            context,
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
                SizedBox(height: 48.h),

                // Section 3: App info logo
                Center(
                  child: Column(
                    children: [
                      Text(
                        'SKYGLASS WEATHER',
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
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: context.text.bodySmall!.copyWith(
        color: context.ext.colors.textSecondary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.ext.colors.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.ext.colors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.ext.colors.primaryLight,
            ),
            child: Icon(icon, color: context.ext.colors.primary, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              style: context.text.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildUnitOption(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? context.ext.colors.primary : context.ext.colors.greyExtraLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          label,
          style: context.text.bodyMedium!.copyWith(
            color: isSelected ? Colors.white : context.ext.colors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
