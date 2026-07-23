import 'package:dio/dio.dart';
import '../../constants/api_keys.dart';

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['key'] = Api.apiKey;
    super.onRequest(options, handler);
  }
}
