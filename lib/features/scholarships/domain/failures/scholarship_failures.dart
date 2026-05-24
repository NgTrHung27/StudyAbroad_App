import 'package:equatable/equatable.dart';

abstract class ScholarshipFailure extends Equatable {
  final String message;
  const ScholarshipFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ScholarshipNetworkFailure extends ScholarshipFailure {
  const ScholarshipNetworkFailure([String? message])
      : super(message ?? 'No internet connection');
}

class ScholarshipServerFailure extends ScholarshipFailure {
  final int? statusCode;
  const ScholarshipServerFailure([String? message, this.statusCode])
      : super(message ?? 'Server error occurred');
}

class ScholarshipUnknownFailure extends ScholarshipFailure {
  const ScholarshipUnknownFailure([String? message])
      : super(message ?? 'An unexpected error occurred');
}
