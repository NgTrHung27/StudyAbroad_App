import 'package:bloc/bloc.dart';
import 'package:kltn_mobile/blocs/news_cubit_bloc/news_school_state.dart';
import 'package:kltn_mobile/blocs/repository/repository.dart';
import 'package:kltn_mobile/models/news_school.dart';

class NewsSchoolCubit extends Cubit<NewsSchoolState> {
  NewsSchoolCubit() : super(NewsSchoolInitial());
  APIRepository apiRepository = APIRepository();

  Future<void> getNewsByUserSchool(String nameSchool) async {
    emit(NewsSchoolLoading());
    try {
      List<NewsSchoolList> newsSchoolList =
          await apiRepository.fetchSchoolNews();
      //Filter
      List<NewsSchoolList> newsSchoolListfiltered = newsSchoolList
          .where((newsSchoolList) => newsSchoolList.school?.name == nameSchool)
          .toList();
      emit(NewsSchoolLoaded(newsSchoolList: newsSchoolListfiltered));
    } catch (e) {
      emit(NewsSchoolError(message: e.toString()));
    }
  }
}
