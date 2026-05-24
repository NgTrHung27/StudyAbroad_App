import 'package:dio/dio.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_interceptor.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';

class ApiHelper {
  late final Dio _dio;

  ApiHelper() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );
    _dio.interceptors.add(ApiInterceptor());
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Handle successful response
  Response _handleResponse(Response response) {
    return response;
  }

  // Handle Dio exceptions and convert to app exceptions
  Exception _handleDioException(DioException e) {
    if (e.error is NetworkException) {
      return e.error as NetworkException;
    }
    if (e.error is UnauthorizedException) {
      return e.error as UnauthorizedException;
    }
    if (e.error is ServerException) {
      return e.error as ServerException;
    }

    // Handle connection errors
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException(
        message: 'Connection failed. Please check your internet connection.',
      );
    }

    // Handle response errors
    if (e.response != null) {
      return ServerException(
        message: _extractErrorMessage(e.response),
        statusCode: e.response?.statusCode,
      );
    }

    return ServerException(message: e.message);
  }

  // Extract error message from response
  String? _extractErrorMessage(Response? response) {
    if (response?.data is String) {
      return response?.data;
    }
    if (response?.data is Map) {
      final data = response!.data as Map;
      return data['message'] ?? data['error'] ?? data['msg'];
    }
    return 'An error occurred';
  }
}
