import 'package:equatable/equatable.dart';

abstract class SchoolFailure extends Equatable {
  final String message;

  const SchoolFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class SchoolServerFailure extends SchoolFailure {
  const SchoolServerFailure([super.message = 'Server failure occurred']);
}

class SchoolNetworkFailure extends SchoolFailure {
  const SchoolNetworkFailure([super.message = 'Network connection failed']);
}

class SchoolNotFoundFailure extends SchoolFailure {
  const SchoolNotFoundFailure([super.message = 'Schools not found']);
}
