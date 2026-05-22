import 'package:study_abroad_cemc_mobile/core/errors/exceptions.dart';
import 'package:study_abroad_cemc_mobile/core/errors/failures.dart';

/// Converts Exceptions to Failures following Clean Architecture pattern
Failure convertExceptionToFailure(dynamic exception) {
  if (exception is ServerException) {
    return ServerFailure(
      message: exception.message,
      statusCode: exception.statusCode,
      originalError: exception.originalError,
    );
  }

  if (exception is NetworkException) {
    return const NetworkFailure();
  }

  if (exception is CacheException) {
    return const CacheFailure();
  }

  if (exception is AuthException) {
    return AuthFailure(
      message: exception.message,
      originalError: exception.originalError,
    );
  }

  if (exception is ValidationException) {
    return ValidationFailure(
      message: exception.message,
      fieldErrors: exception.errors,
      originalError: exception.originalError,
    );
  }

  if (exception is TimeoutException) {
    return const TimeoutFailure();
  }

  if (exception is ParseException) {
    return const ServerFailure(message: 'Failed to process server response');
  }

  return UnknownFailure(originalError: exception);
}

/// Maps status codes to user-friendly messages
String mapStatusCodeToMessage(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Bad request. Please check your input.';
    case 401:
      return 'Unauthorized. Please login again.';
    case 403:
      return 'Access denied.';
    case 404:
      return 'Resource not found.';
    case 406:
      return 'Not acceptable. Please check your data.';
    case 409:
      return 'Conflict. This data already exists.';
    case 422:
      return 'Validation error. Please check your input.';
    case 429:
      return 'Too many requests. Please try again later.';
    case 500:
      return 'Server error. Please try again later.';
    case 502:
      return 'Bad gateway. Please try again later.';
    case 503:
      return 'Service unavailable. Please try again later.';
    default:
      return 'An error occurred. Status code: $statusCode';
  }
}

/// Formats error messages from API responses
String? extractErrorMessage(Map<String, dynamic>? response) {
  if (response == null) return null;

  // Try common error field patterns
  if (response.containsKey('message')) {
    return response['message']?.toString();
  }

  if (response.containsKey('error')) {
    final error = response['error'];
    if (error is String) return error;
    if (error is Map<String, dynamic>) {
      if (error.containsKey('message')) {
        return error['message']?.toString();
      }
    }
    if (error is List && error.isNotEmpty) {
      return error.first.toString();
    }
  }

  if (response.containsKey('errors')) {
    final errors = response['errors'];
    if (errors is List && errors.isNotEmpty) {
      return errors.map((e) => e.toString()).join(', ');
    }
  }

  return null;
}
