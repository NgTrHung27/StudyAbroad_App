/// Base exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// Exception thrown when server returns an error
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error occurred',
    super.statusCode,
    super.originalError,
  });
}

/// Exception thrown when there's no internet connection
class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection',
    super.originalError,
  });
}

/// Exception thrown when cache operation fails
class CacheException extends ApiException {
  const CacheException({
    super.message = 'Cache operation failed',
    super.originalError,
  });
}

/// Exception thrown when parsing data fails
class ParseException extends ApiException {
  const ParseException({
    super.message = 'Failed to parse data',
    super.originalError,
  });
}

/// Exception thrown when authentication fails
class AuthException extends ApiException {
  const AuthException({
    super.message = 'Authentication failed',
    super.statusCode,
    super.originalError,
  });
}

/// Exception thrown when request times out
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.originalError,
  });
}

/// Exception thrown when validation fails
class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Validation failed',
    this.errors,
    super.originalError,
  });
}
