import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_task_app/core/error/error_handler.dart';
import 'package:weather_task_app/core/error/failure.dart';
import 'package:weather_task_app/core/network/network_info.dart';
import 'package:weather_task_app/core/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/core/weather/domain/repositories/weather_repository.dart';

@LazySingleton(as: WeatherRepository)
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherForecast(String city) async {
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
