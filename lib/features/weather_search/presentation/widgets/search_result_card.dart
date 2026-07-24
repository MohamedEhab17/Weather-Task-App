import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_search/presentation/cubit/search_cubit.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.weather,
    required this.isCelsius,
    required this.onSelectCity,
    required this.onFetchCity,
    required this.onToggleFavorite,
  });

  final WeatherEntity weather;
  final bool isCelsius;
  final VoidCallback onSelectCity;
  final void Function(String city) onFetchCity;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final isFav = context.read<SearchCubit>().isFavorite(weather.locationName);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.ext.colors.primaryLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.ext.colors.primary.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                onFetchCity(weather.locationName);
                onSelectCity();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.locationName,
                    style: context.text.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    weather.conditionText,
                    style: context.text.bodyMedium!.copyWith(
                      color: context.ext.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            isCelsius ? '${weather.tempC.round()}°' : '${weather.tempF.round()}°',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: context.ext.colors.textPrimary,
            ),
          ),
          SizedBox(width: 16.w),
          IconButton(
            icon: Icon(
              isFav ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isFav ? Colors.amber : context.ext.colors.textSecondary,
              size: 28.sp,
            ),
            onPressed: () {
              context.read<SearchCubit>().toggleFavorite(weather.locationName);
              onToggleFavorite();
            },
          ),
        ],
      ),
    );
  }
}
