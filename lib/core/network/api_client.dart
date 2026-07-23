import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<Response> get(String path, {Options? options, Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, options: options, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    return await dio.post(path, data: data, options: options);
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    return await dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
      return await dio.delete(path, data: data, options: options);
  }

  Future<Response> patch(
      String path, {
      dynamic data,
      Options? options,
    }) async {
      return await dio.patch(path, data: data, options: options);
    }
  }

