import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/repositories/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _repository;

  NewsBloc({required NewsRepository repository})
      : _repository = repository,
        super(NewsInitial()) {
    on<LoadGeneralNewsEvent>(_onLoadGeneralNews);
    on<LoadSchoolNewsEvent>(_onLoadSchoolNews);
  }

  Future<void> _onLoadGeneralNews(
    LoadGeneralNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    final result = await _repository.getGeneralNews();
    result.fold(
      (failure) => emit(NewsError(message: failure.message, failure: failure)),
      (newsList) => emit(NewsLoaded(newsList: newsList)),
    );
  }

  Future<void> _onLoadSchoolNews(
    LoadSchoolNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    final result = await _repository.getSchoolNews(event.schoolName);
    result.fold(
      (failure) => emit(NewsError(message: failure.message, failure: failure)),
      (newsList) => emit(NewsLoaded(newsList: newsList)),
    );
  }
}
