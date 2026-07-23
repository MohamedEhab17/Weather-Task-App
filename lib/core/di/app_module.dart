import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../network/dio_factory.dart';

@module
abstract class AppModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  Dio get dio => DioFactory.create();

  @lazySingleton
  ApiClient apiClient(Dio dio) => ApiClient(dio);

  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
