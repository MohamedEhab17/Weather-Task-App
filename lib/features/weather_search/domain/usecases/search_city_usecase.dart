import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_task_app/core/base/usecase.dart';
import 'package:weather_task_app/core/error/failure.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_search/domain/repositories/search_repository.dart';

@lazySingleton
class SearchCityUseCase implements UseCase<WeatherEntity, String> {
  final SearchRepository repository;

  SearchCityUseCase(this.repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(String city) async {
    return await repository.searchCity(city);
  }
}
