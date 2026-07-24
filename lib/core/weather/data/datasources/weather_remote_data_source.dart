import 'package:injectable/injectable.dart';
import 'package:weather_task_app/core/constants/api_keys.dart';
import 'package:weather_task_app/core/network/api_client.dart';
import 'package:weather_task_app/core/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeatherForecast(String city);
}

@LazySingleton(as: WeatherRemoteDataSource)
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiClient apiClient;

  WeatherRemoteDataSourceImpl(this.apiClient);

  @override
  Future<WeatherModel> getWeatherForecast(String city) async {
    final response = await apiClient.get(
      Api.forecast,
      queryParameters: {'q': city, 'days': 3},
    );
    return WeatherModel.fromJson(response.data as Map<String, dynamic>);
  }
}
