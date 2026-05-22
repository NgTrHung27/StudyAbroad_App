import 'package:equatable/equatable.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsEntity> newsList;

  const NewsLoaded({required this.newsList});

  @override
  List<Object?> get props => [newsList];
}

class NewsError extends NewsState {
  final String message;
  final NewsFailure? failure;

  const NewsError({required this.message, this.failure});

  @override
  List<Object?> get props => [message, failure];
}
