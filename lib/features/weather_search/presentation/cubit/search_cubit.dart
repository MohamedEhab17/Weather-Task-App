import 'package:injectable/injectable.dart';
import 'package:weather_task_app/core/base/safe_cubit.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_search/domain/usecases/get_favorites_usecase.dart';
import 'package:weather_task_app/features/weather_search/domain/usecases/search_city_usecase.dart';
import 'package:weather_task_app/features/weather_search/domain/usecases/toggle_favorite_usecase.dart';
import 'package:weather_task_app/features/weather_search/presentation/cubit/search_state.dart';

@lazySingleton
class SearchCubit extends SafeCubit<SearchState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final SearchCityUseCase searchCityUseCase;

  SearchCubit({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
    required this.searchCityUseCase,
  }) : super(const SearchState());

  Future<void> init() async {
    final list = getFavoritesUseCase();
    emit(SearchState(
      status: SearchStatus.initial,
      favoritesList: list,
      favoritesWeather: const {},
    ));
    await loadFavoritesWeather();
  }

  Future<void> loadFavoritesWeather() async {
    final Map<String, WeatherEntity> favoritesWeather = Map.from(state.favoritesWeather);
    for (final city in state.favoritesList) {
      final result = await searchCityUseCase(city);
      result.fold(
        (failure) {},
        (weather) {
          favoritesWeather[city.toLowerCase()] = weather;
        },
      );
    }
    emit(state.copyWith(favoritesWeather: favoritesWeather));
  }

  Future<void> toggleFavorite(String city) async {
    final updatedList = await toggleFavoriteUseCase(city);
    final cleanCity = city.trim();
    final lowerCity = cleanCity.toLowerCase();

    final Map<String, WeatherEntity> favoritesWeather = Map.from(state.favoritesWeather);
    if (favoritesWeather.containsKey(lowerCity)) {
      favoritesWeather.remove(lowerCity);
    } else {
      final result = await searchCityUseCase(cleanCity);
      result.fold(
        (failure) {},
        (weather) {
          favoritesWeather[lowerCity] = weather;
        },
      );
    }

    emit(state.copyWith(
      favoritesList: updatedList,
      favoritesWeather: favoritesWeather,
    ));
  }

  bool isFavorite(String city) {
    return state.favoritesList.any((element) => element.toLowerCase() == city.trim().toLowerCase());
  }
}
