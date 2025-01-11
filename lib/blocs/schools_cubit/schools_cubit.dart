import 'package:bloc/bloc.dart';
import 'package:kltn_mobile/blocs/repository/repository.dart';
import 'package:kltn_mobile/models/schools.dart';

part 'schools_state.dart';

class SchoolsCubit extends Cubit<SchoolsState> {
  SchoolsCubit() : super(SchoolsInitial());
  APIRepository apiRepository = APIRepository();

  void getSchoolList() async {
    emit(SchoolsLoading());
    try {
      List<Schools> schoolList = await apiRepository.fetchSchools();
      emit(SchoolsLoaded(schoolList: schoolList));
    } catch (e) {
      emit(SchoolsError(message: e.toString()));
    }
  }

    // Thêm vào SchoolsCubit
  void getSchoolListByCountry(String country) async {
    emit(SchoolsLoading());
    try {
      List<Schools> schoolList = await apiRepository.fetchSchools();
      // Lọc danh sách trường học theo quốc gia
      List<Schools> filteredList = schoolList.where((school) => school.country == country).toList();
      emit(SchoolsLoaded(schoolList: filteredList));
    } catch (e) {
      emit(SchoolsError(message: e.toString()));
    }
  }
}
