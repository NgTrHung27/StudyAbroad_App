/// Custom API Exception class
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  const ApiException({
    required this.statusCode,
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';

  /// Factory constructors for common error types
  factory ApiException.unauthorized() => const ApiException(
        statusCode: 401,
        message: 'Unauthorized. Please login again.',
      );

  factory ApiException.forbidden() => const ApiException(
        statusCode: 403,
        message: 'Access denied.',
      );

  factory ApiException.notFound() => const ApiException(
        statusCode: 404,
        message: 'Resource not found.',
      );

  factory ApiException.serverError() => const ApiException(
        statusCode: 500,
        message: 'Server error. Please try again later.',
      );

  factory ApiException.networkError() => const ApiException(
        statusCode: 0,
        message: 'No internet connection.',
      );

  factory ApiException.validationError(Map<String, dynamic>? errors) =>
      ApiException(
        statusCode: 400,
        message: 'Validation failed.',
        errors: errors,
      );
}

/// Server failure for Either type
class ServerFailure {
  final int? statusCode;
  final String? message;
  final Map<String, dynamic>? errors;

  const ServerFailure({
    this.statusCode,
    this.message,
    this.errors,
  });

  factory ServerFailure.fromException(ApiException e) => ServerFailure(
        statusCode: e.statusCode,
        message: e.message,
        errors: e.errors,
      );

  factory ServerFailure.unknown([String? message]) => ServerFailure(
        message: message ?? 'An unknown error occurred.',
      );

  factory ServerFailure.network() => const ServerFailure(
        statusCode: 0,
        message: 'No internet connection.',
      );

  factory ServerFailure.timeout() => const ServerFailure(
        statusCode: 408,
        message: 'Request timeout.',
      );

  @override
  String toString() => message ?? 'Unknown error';
}

/// Cache failure for local storage errors
class CacheFailure {
  final String? message;

  const CacheFailure([this.message]);

  @override
  String toString() => message ?? 'Cache error';
}

/// Validation failure
class ValidationFailure {
  final Map<String, dynamic>? errors;
  final String? message;

  const ValidationFailure({
    this.errors,
    this.message,
  });

  @override
  String toString() => message ?? 'Validation error';
}
