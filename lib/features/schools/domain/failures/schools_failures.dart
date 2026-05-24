abstract class SchoolsFailure {
  final String? message;
  const SchoolsFailure({this.message});
  
  List<Object?> get props => [message];
}

class SchoolsServerFailure extends SchoolsFailure {
  const SchoolsServerFailure([String? message]) : super(message: message ?? 'Server failure occurred');
}

class SchoolsNetworkFailure extends SchoolsFailure {
  const SchoolsNetworkFailure([String? message]) : super(message: message ?? 'Network connection failed');
}

class SchoolsNotFoundFailure extends SchoolsFailure {
  const SchoolsNotFoundFailure([String? message]) : super(message: message ?? 'Schools not found');
}

class SchoolsParseFailure extends SchoolsFailure {
  const SchoolsParseFailure([String? message]) : super(message: message ?? 'Failed to parse data');
}
