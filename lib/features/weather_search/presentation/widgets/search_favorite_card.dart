import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/helper/app_toast.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/theme/weather_theme_helper.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_search/presentation/cubit/search_cubit.dart';

class SearchFavoriteCard extends StatelessWidget {
  const SearchFavoriteCard({
    super.key,
    required this.city,
    required this.weather,
    required this.isCelsius,
    required this.isEditMode,
    required this.onSelectCity,
    required this.onFetchCity,
  });

  final String city;
  final WeatherEntity? weather;
  final bool isCelsius;
  final bool isEditMode;
  final VoidCallback onSelectCity;
  final void Function(String city) onFetchCity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(city),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: context.isAr ? Alignment.centerLeft : Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: context.ext.colors.error,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              title: Text(
                context.trContext(TK.removeFavoriteTitle),
                style: context.text.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.ext.colors.textPrimary,
                ),
              ),
              content: Text(
                context.trContext(TK.removeFavoriteBody, namedArgs: {'city': city}),
                style: context.text.bodyMedium!.copyWith(
                  color: context.ext.colors.textSecondary,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    context.trContext(TK.cancel),
                    style: context.text.bodyMedium!.copyWith(
                      color: context.ext.colors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.ext.colors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  ),
                  child: Text(
                    context.trContext(TK.delete),
                    style: context.text.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<SearchCubit>().toggleFavorite(city);
        AppToast.success(context, message: context.trContext(TK.removedToast, namedArgs: {'city': city}));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: WeatherThemeHelper.getCardGradient(weather, isDark),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: context.ext.colors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onFetchCity(city);
                onSelectCity();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            city,
                            style: context.text.titleMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            weather != null ? weather!.conditionText : '...',
                            style: context.text.bodyMedium!.copyWith(
                              color: context.ext.colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (weather != null) ...[
                      Image.network(
                        'https:${weather!.conditionIcon}',
                        width: 40.w,
                        height: 40.w,
                        errorBuilder: (context, e, s) => const SizedBox(),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        isCelsius ? '${weather!.tempC.round()}°' : '${weather!.tempF.round()}°',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: context.ext.colors.textPrimary,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                    if (isEditMode) ...[
                      SizedBox(width: 16.w),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline_rounded,
                          color: context.ext.colors.error,
                        ),
                        onPressed: () {
                          context.read<SearchCubit>().toggleFavorite(city);
                          AppToast.success(context, message: context.trContext(TK.removedToast, namedArgs: {'city': city}));
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
