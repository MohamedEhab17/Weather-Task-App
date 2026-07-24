import 'package:dartz/dartz.dart';
import 'package:weather_task_app/core/error/failure.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeatherForecast(String city);
}
