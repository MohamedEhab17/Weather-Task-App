import 'dart:developer';
import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    log('ERROR_HANDLER: Handling error: $error (${error.runtimeType})');
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    } else if (error is CacheException) {
      return CacheFailure(error.message);
    } else {
      return UnknownFailure(error.toString());
    }
  }

  static Failure _handleDioError(DioException error) {
    log('ERROR_HANDLER: DioException type: ${error.type}, message: ${error.message}, statusCode: ${error.response?.statusCode}');
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Connection timeout with API server');
      
      case DioExceptionType.badResponse:
        final response = error.response;
        if (response != null && response.data != null) {
          final data = response.data;
          if (data is Map<String, dynamic>) {
            if (data.containsKey('message')) {
              return ServerFailure(data['message']);
            }
            if (data.containsKey('error')) {
              final err = data['error'];
              if (err is Map<String, dynamic> && err.containsKey('message')) {
                return ServerFailure(err['message']);
              }
            }
          }
        }
        return ServerFailure('Received invalid status code: ${response?.statusCode}');
      
      case DioExceptionType.cancel:
        return const ServerFailure('Request to API server was cancelled');
      
      case DioExceptionType.connectionError:
        return const ServerFailure('No internet connection');
      
      case DioExceptionType.unknown:
      default:
        return const ServerFailure('Unexpected error occurred');
    }
  }
}
