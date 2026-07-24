import 'package:equatable/equatable.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

enum SearchStatus { initial, loading, success, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<String> favoritesList;
  final Map<String, WeatherEntity> favoritesWeather;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.favoritesList = const [],
    this.favoritesWeather = const {},
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<String>? favoritesList,
    Map<String, WeatherEntity>? favoritesWeather,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      favoritesList: favoritesList ?? this.favoritesList,
      favoritesWeather: favoritesWeather ?? this.favoritesWeather,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, favoritesList, favoritesWeather, errorMessage];
}
