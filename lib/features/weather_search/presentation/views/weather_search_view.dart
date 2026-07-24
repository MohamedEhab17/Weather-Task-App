import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/di/injection.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/helper/app_toast.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/core/widgets/custom_loading_indicator.dart';
import 'package:weather_task_app/features/weather_search/domain/usecases/search_city_usecase.dart';
import 'package:weather_task_app/features/weather_search/presentation/cubit/search_cubit.dart';
import 'package:weather_task_app/features/weather_search/presentation/cubit/search_state.dart';
import 'package:weather_task_app/features/weather_search/presentation/widgets/search_favorite_card.dart';
import 'package:weather_task_app/features/weather_search/presentation/widgets/search_input_field.dart';
import 'package:weather_task_app/features/weather_search/presentation/widgets/search_result_card.dart';

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
              SearchInputField(
                controller: _searchController,
                onSubmitted: _performSearch,
                onClear: () {
                  _searchController.clear();
                  setState(() {
                    _searchResult = null;
                    _searchError = null;
                  });
                },
                onChanged: (val) => setState(() {}),
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
                SearchResultCard(
                  weather: _searchResult!,
                  isCelsius: isCelsius,
                  onSelectCity: widget.onSelectCity,
                  onFetchCity: widget.onFetchCity,
                  onToggleFavorite: () => setState(() {}),
                ),

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

                          return SearchFavoriteCard(
                            city: city,
                            weather: weather,
                            isCelsius: isCelsius,
                            isEditMode: _isEditMode,
                            onSelectCity: widget.onSelectCity,
                            onFetchCity: widget.onFetchCity,
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
}
