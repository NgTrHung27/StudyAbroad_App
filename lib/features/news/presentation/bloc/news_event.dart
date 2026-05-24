import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNewsEvent extends NewsEvent {
  const LoadNewsEvent();
}

class LoadGeneralNewsEvent extends NewsEvent {
  const LoadGeneralNewsEvent();
}

class LoadSchoolNewsEvent extends NewsEvent {
  final String schoolName;

  const LoadSchoolNewsEvent(this.schoolName);

  @override
  List<Object?> get props => [schoolName];
}

class LoadNewsByIdEvent extends NewsEvent {
  final String newsId;

  const LoadNewsByIdEvent(this.newsId);

  @override
  List<Object?> get props => [newsId];
}
