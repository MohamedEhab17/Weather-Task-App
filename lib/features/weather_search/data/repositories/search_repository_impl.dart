import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_task_app/core/error/error_handler.dart';
import 'package:weather_task_app/core/error/failure.dart';
import 'package:weather_task_app/core/network/network_info.dart';
import 'package:weather_task_app/core/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_search/data/datasources/search_local_data_source.dart';
import 'package:weather_task_app/features/weather_search/domain/repositories/search_repository.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource localDataSource;
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  List<String> getFavorites() {
    return localDataSource.getFavorites();
  }

  @override
  Future<void> saveFavorites(List<String> favorites) async {
    await localDataSource.saveFavorites(favorites);
  }

  @override
  Future<Either<Failure, WeatherEntity>> searchCity(String city) async {
    if (await networkInfo.isConnected) {
      try {
        final weather = await remoteDataSource.getWeatherForecast(city);
        return Right(weather);
      } catch (e) {
        return Left(ErrorHandler.handle(e));
      }
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  }
}
