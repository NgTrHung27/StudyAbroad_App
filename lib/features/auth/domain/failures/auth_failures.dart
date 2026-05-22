import 'package:equatable/equatable.dart';

/// Base class for all auth failures
abstract class AuthFailure extends Equatable {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Wrong credentials
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Invalid email or password');
}

/// Email already exists
class EmailAlreadyExistsFailure extends AuthFailure {
  const EmailAlreadyExistsFailure() : super('Email already registered');
}

/// Account locked
class AccountLockedFailure extends AuthFailure {
  const AccountLockedFailure() : super('Account is locked');
}

/// Email not verified
class EmailNotVerifiedFailure extends AuthFailure {
  const EmailNotVerifiedFailure() : super('Please verify your email');
}

/// Invalid token
class InvalidTokenFailure extends AuthFailure {
  const InvalidTokenFailure() : super('Invalid or expired token');
}

/// Network error
class NetworkErrorFailure extends AuthFailure {
  const NetworkErrorFailure() : super('No internet connection');
}

/// Server error
class ServerErrorFailure extends AuthFailure {
  final int? statusCode;
  const ServerErrorFailure([this.statusCode]) : super('Server error occurred');
}

/// Validation errors
class ValidationErrorFailure extends AuthFailure {
  final Map<String, List<String>>? fieldErrors;
  const ValidationErrorFailure([this.fieldErrors]) : super('Validation failed');
}

/// Unknown error
class UnknownErrorFailure extends AuthFailure {
  const UnknownErrorFailure() : super('An unexpected error occurred');
}
