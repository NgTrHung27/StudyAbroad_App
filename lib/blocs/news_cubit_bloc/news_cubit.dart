import 'package:bloc/bloc.dart';
import 'package:kltn_mobile/blocs/repository/repository.dart';
import 'package:kltn_mobile/models/news.dart';
import 'package:meta/meta.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());
  APIRepository apiRepository = APIRepository();

  void getNewsList(dynamic nullSchool) async {
    emit(NewsLoading());
    try {
      List<NewsList> newsList = await apiRepository.fetchNews();

      List<NewsList> nullFieldsNewsList =
          newsList.where((newsList) => newsList.school?.name == null).toList();
      emit(NewsLoaded(newsList: nullFieldsNewsList));
    } catch (e) {
      emit(NewsError(message: e.toString()));
    }
  }
}
