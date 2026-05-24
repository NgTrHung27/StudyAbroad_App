import 'package:equatable/equatable.dart';

abstract class ContactFailure extends Equatable {
  final String message;
  const ContactFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactNetworkFailure extends ContactFailure {
  const ContactNetworkFailure([String? message])
      : super(message ?? 'No internet connection');
}

class ContactServerFailure extends ContactFailure {
  final int? statusCode;
  const ContactServerFailure([String? message, this.statusCode])
      : super(message ?? 'Server error occurred');
}

class ContactValidationFailure extends ContactFailure {
  const ContactValidationFailure([String? message])
      : super(message ?? 'Validation failed');
}

class ContactUnknownFailure extends ContactFailure {
  const ContactUnknownFailure([String? message])
      : super(message ?? 'An unexpected error occurred');
}
