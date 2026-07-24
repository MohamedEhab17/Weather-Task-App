import 'package:dartz/dartz.dart';
import 'package:weather_task_app/core/error/failure.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

abstract class SearchRepository {
  List<String> getFavorites();
  Future<void> saveFavorites(List<String> favorites);
  Future<Either<Failure, WeatherEntity>> searchCity(String city);
}
