abstract class NewsFailure {
  final String? message;
  const NewsFailure({this.message});
  
  List<Object?> get props => [message];
}

class NewsServerFailure extends NewsFailure {
  const NewsServerFailure([String? message]) : super(message: message ?? 'Server failure occurred');
}

class NewsNetworkFailure extends NewsFailure {
  const NewsNetworkFailure([String? message]) : super(message: message ?? 'Network connection failed');
}

class NewsNotFoundFailure extends NewsFailure {
  const NewsNotFoundFailure([String? message]) : super(message: message ?? 'News not found');
}

class NewsParseFailure extends NewsFailure {
  const NewsParseFailure([String? message]) : super(message: message ?? 'Failed to parse data');
}
