import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
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
