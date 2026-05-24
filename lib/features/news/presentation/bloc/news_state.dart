import 'package:equatable/equatable.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';

/// Phân biệt loại tin tức để tránh race condition khi share NewsBloc
enum NewsType { general, school, all }

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {
  final NewsType newsType;
  const NewsLoading({this.newsType = NewsType.all});

  @override
  List<Object?> get props => [newsType];
}

class NewsLoaded extends NewsState {
  final List<NewsEntity> newsList;
  final NewsType newsType;

  const NewsLoaded({required this.newsList, required this.newsType});

  @override
  List<Object?> get props => [newsList, newsType];
}

class NewsDetailLoaded extends NewsState {
  final NewsEntity news;

  const NewsDetailLoaded({required this.news});

  @override
  List<Object?> get props => [news];
}

class NewsError extends NewsState {
  final String message;
  final NewsFailure? failure;
  final NewsType newsType;

  const NewsError({required this.message, this.failure, this.newsType = NewsType.all});

  @override
  List<Object?> get props => [message, failure, newsType];
}
