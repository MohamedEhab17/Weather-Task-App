import 'package:dio/dio.dart';
import 'package:weather_task_app/core/constants/api_keys.dart';
import 'package:weather_task_app/core/network/interceptors/api_key_interceptor.dart';

class DioFactory {
  static Dio create() {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: Api.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      followRedirects: true,
      validateStatus: (status) => status != null && status < 500,
    );

    // Pass the Dio instance to ApiKeyInterceptor to append keys automatically
    dio.interceptors.add(ApiKeyInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }
}