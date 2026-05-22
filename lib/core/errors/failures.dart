import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, originalError];
}

/// Server failure - when API returns error
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    super.message = 'Server error occurred',
    this.statusCode,
    super.originalError,
  });

  @override
  List<Object?> get props => [message, statusCode, originalError];
}

/// Network failure - no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.originalError,
  });
}

/// Cache failure - local storage error
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache operation failed',
    super.originalError,
  });
}

/// Authentication failure - login/register errors
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed',
    super.originalError,
  });
}

/// Validation failure - form validation errors
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    super.message = 'Validation failed',
    this.fieldErrors,
    super.originalError,
  });

  @override
  List<Object?> get props => [message, fieldErrors, originalError];
}

/// Timeout failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out',
    super.originalError,
  });
}

/// Unknown failure - unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred',
    super.originalError,
  });
}

/// Credential failure - wrong email/password
class CredentialFailure extends AuthFailure {
  const CredentialFailure({
    super.message = 'Wrong email or password',
  });
}

/// Token expired failure
class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure({
    super.message = 'Session expired. Please login again',
  });
}

/// No data failure - when expected data is not found
class NoDataFailure extends Failure {
  const NoDataFailure({
    super.message = 'No data found',
  });
}
