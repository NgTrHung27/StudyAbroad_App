import 'package:equatable/equatable.dart';

abstract class NewsFailure extends Equatable {
  final String message;

  const NewsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class NewsServerFailure extends NewsFailure {
  const NewsServerFailure([super.message = 'Server failure occurred']);
}

class NewsNetworkFailure extends NewsFailure {
  const NewsNetworkFailure([super.message = 'Network connection failed']);
}
