import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/usecases/get_news_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/usecases/get_news_by_id_usecase.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;
  final GetNewsByIdUseCase getNewsByIdUseCase;

  NewsBloc({
    required this.getNewsUseCase,
    required this.getNewsByIdUseCase,
  }) : super(NewsInitial()) {
    on<LoadNewsEvent>(_onLoadNews);
    on<LoadGeneralNewsEvent>(_onLoadGeneralNews);
    on<LoadSchoolNewsEvent>(_onLoadSchoolNews);
    on<LoadNewsByIdEvent>(_onLoadNewsById);
  }

  Future<void> _onLoadNews(
    LoadNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading(newsType: NewsType.all));
    final result = await getNewsUseCase();
    result.fold(
      (failure) => emit(NewsError(
        message: _mapFailureToMessage(failure),
        failure: failure,
        newsType: NewsType.all,
      )),
      (newsList) => emit(NewsLoaded(newsList: newsList, newsType: NewsType.all)),
    );
  }

  Future<void> _onLoadGeneralNews(
    LoadGeneralNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading(newsType: NewsType.general));
    final result = await getNewsUseCase();
    result.fold(
      (failure) => emit(NewsError(
        message: _mapFailureToMessage(failure),
        failure: failure,
        newsType: NewsType.general,
      )),
      (allNews) {
        final generalNews = allNews.where((news) => news.school?.name == null).toList();
        emit(NewsLoaded(newsList: generalNews, newsType: NewsType.general));
      },
    );
  }

  Future<void> _onLoadSchoolNews(
    LoadSchoolNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading(newsType: NewsType.school));
    final result = await getNewsUseCase();
    result.fold(
      (failure) => emit(NewsError(
        message: _mapFailureToMessage(failure),
        failure: failure,
        newsType: NewsType.school,
      )),
      (allNews) {
        final schoolNews = allNews.where((news) => news.school?.name == event.schoolName).toList();
        emit(NewsLoaded(newsList: schoolNews, newsType: NewsType.school));
      },
    );
  }

  Future<void> _onLoadNewsById(
    LoadNewsByIdEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading(newsType: NewsType.all));
    final result = await getNewsByIdUseCase(event.newsId);
    result.fold(
      (failure) => emit(NewsError(
        message: _mapFailureToMessage(failure),
        failure: failure,
        newsType: NewsType.all,
      )),
      (news) => emit(NewsDetailLoaded(news: news)),
    );
  }

  String _mapFailureToMessage(NewsFailure failure) {
    if (failure is NewsNetworkFailure) {
      return 'Unable to connect to the server. Please check your internet connection.';
    }
    if (failure is NewsNotFoundFailure) {
      return 'News not found.';
    }
    if (failure is NewsParseFailure) {
      return 'Failed to load data. Please try again.';
    }
    return failure.message ?? 'An error occurred. Please try again.';
  }
}
