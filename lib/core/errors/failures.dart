abstract class Failure {
  final String? message;
  const Failure({this.message});
  
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String? message]) : super(message: message ?? 'Server failure occurred');
}

class NetworkFailure extends Failure {
  const NetworkFailure([String? message]) : super(message: message ?? 'Network connection failed');
}

class CacheFailure extends Failure {
  const CacheFailure([String? message]) : super(message: message ?? 'Cache failure occurred');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String? message]) : super(message: message ?? 'Unauthorized access');
}

class ValidationFailure extends Failure {
  const ValidationFailure([String? message]) : super(message: message ?? 'Validation failed');
}
