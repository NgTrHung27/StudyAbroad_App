import 'package:dio/dio.dart';
import 'package:study_abroad_cemc_mobile/core/cache/local_storage.dart';
import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    // Add auth token if available
    final token = LocalStorage.getString(StorageKeys.token);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Detect HTML responses (e.g. Vercel 404 pages) and reject them
    final data = response.data;
    if (data is String &&
        (data.trimLeft().startsWith('<!DOCTYPE') ||
            data.trimLeft().startsWith('<html'))) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: ServerException(
            message: 'Server returned an unexpected response (status: ${response.statusCode})',
            statusCode: response.statusCode,
          ),
        ),
      );
      return;
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException(
              message: 'Connection timeout. Please check your internet connection.',
            ),
            type: DioExceptionType.connectionTimeout,
          ),
        );
        break;
      case DioExceptionType.badResponse:
        _handleBadResponse(err, handler);
        break;
      case DioExceptionType.cancel:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException(message: 'Request cancelled'),
            type: DioExceptionType.cancel,
          ),
        );
        break;
      default:
        handler.next(err);
    }
  }

  void _handleBadResponse(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    switch (statusCode) {
      case 400:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(
              message: 'Bad request',
              statusCode: statusCode,
            ),
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
        break;
      case 401:
      case 403:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnauthorizedException(
              message: 'Unauthorized access',
            ),
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
        break;
      case 404:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(
              message: 'Resource not found',
              statusCode: statusCode,
            ),
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
        break;
      case 500:
      case 502:
      case 503:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(
              message: 'Server error. Please try again later.',
              statusCode: statusCode,
            ),
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
        break;
      default:
        handler.next(err);
    }
  }
}
