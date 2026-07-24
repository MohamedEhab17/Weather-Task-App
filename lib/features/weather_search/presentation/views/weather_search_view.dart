import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/di/injection.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/helper/app_toast.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/widgets/custom_loading_indicator.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_search/domain/usecases/search_city_usecase.dart';
import 'package:weather_task_app/features/weather_search/presentation/cubit/search_cubit.dart';
import 'package:weather_task_app/features/weather_search/presentation/cubit/search_state.dart';

import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';
import 'package:weather_task_app/core/theme/weather_theme_helper.dart';

class WeatherSearchView extends StatefulWidget {
  final VoidCallback onSelectCity;
  final void Function(String city) onFetchCity;

  const WeatherSearchView({
    super.key,
    required this.onSelectCity,
    required this.onFetchCity,
  });

  @override
  State<WeatherSearchView> createState() => _WeatherSearchViewState();
}

class _WeatherSearchViewState extends State<WeatherSearchView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  WeatherEntity? _searchResult;
  String? _searchError;
  bool _isEditMode = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResult = null;
      _searchError = null;
    });

    final searchCityUseCase = getIt<SearchCityUseCase>();
    final result = await searchCityUseCase(query.trim());

    result.fold(
      (failure) {
        setState(() {
          _isSearching = false;
          _searchError = failure.message;
        });
        AppToast.error(context, message: failure.message);
      },
      (weather) {
        setState(() {
          _isSearching = false;
          _searchResult = weather;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final isCelsius = settingsState.isCelsius;

    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final favoritesList = state.favoritesList;
        final favoritesWeather = state.favoritesWeather;

        return Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              // Search Bar Field
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _performSearch,
                style: context.text.bodyMedium!.copyWith(
                  color: context.ext.colors.textPrimary,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: context.trContext(TK.weatherSearchHint),
                  hintStyle: context.text.bodyMedium!.copyWith(
                    color: context.ext.colors.textSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: context.ext.colors.textSecondary,
                    size: 20.sp,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded, color: context.ext.colors.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchResult = null;
                              _searchError = null;
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: context.ext.colors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(color: context.ext.colors.cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(color: context.ext.colors.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide(color: context.ext.colors.primary, width: 1.5),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                ),
                onChanged: (val) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16.h),

              // Search Results / Loading / Error Section
              if (_isSearching)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CustomLoadingIndicator(size: 40),
                  ),
                )
              else if (_searchError != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: context.ext.colors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.ext.colors.error.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    _searchError!,
                    style: context.text.bodyMedium!.copyWith(
                      color: context.ext.colors.error,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (_searchResult != null)
                _buildSearchResultCard(context, _searchResult!, isCelsius),

              SizedBox(height: 16.h),

              // Favorite Cities Title Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.trContext(TK.favoriteCities),
                    style: context.text.titleMedium!.copyWith(
                      color: context.ext.colors.textSecondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  if (favoritesList.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditMode = !_isEditMode;
                        });
                      },
                      child: Text(
                        _isEditMode ? context.trContext(TK.done) : context.trContext(TK.edit),
                        style: context.text.bodyMedium!.copyWith(
                          color: context.ext.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),

              // Favorites List
              Expanded(
                child: favoritesList.isEmpty
                    ? Center(
                        child: Text(
                          context.trContext(TK.emptyFavorites),
                          style: context.text.bodyMedium!.copyWith(
                            color: context.ext.colors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemCount: favoritesList.length,
                        separatorBuilder: (context, index) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final city = favoritesList[index];
                          final lowerCity = city.toLowerCase();
                          final weather = favoritesWeather[lowerCity];

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
                                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
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
                            child: _buildFavoriteCard(
                              context,
                              city: city,
                              weather: weather,
                              isCelsius: isCelsius,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchResultCard(BuildContext context, WeatherEntity weather, bool isCelsius) {
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
                widget.onFetchCity(weather.locationName);
                widget.onSelectCity();
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
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context, {
    required String city,
    required WeatherEntity? weather,
    required bool isCelsius,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
              widget.onFetchCity(city);
              widget.onSelectCity();
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
                          weather != null ? weather.conditionText : '...',
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
                      'https:${weather.conditionIcon}',
                      width: 40.w,
                      height: 40.w,
                      errorBuilder: (context, e, s) => const SizedBox(),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      isCelsius ? '${weather.tempC.round()}°' : '${weather.tempF.round()}°',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: context.ext.colors.textPrimary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                  if (_isEditMode) ...[
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
    );
  }
}
