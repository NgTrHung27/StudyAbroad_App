import 'package:bloc/bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/repository/repository.dart';
import 'package:study_abroad_cemc_mobile/models/schools.dart';

import 'carousel_event.dart';
import 'carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  final APIRepository repository;

  CarouselBloc(this.repository) : super(CarouselInitial()) {
    on<FetchCarousel>(_onFetchCarousel);
  }

  void _onFetchCarousel(
      FetchCarousel event, Emitter<CarouselState> emit) async {
    emit(CarouselLoading());
    try {
      final List<Schools> carousels = await repository.fetchSchools();
      emit(CarouselLoaded(carousels));
    } catch (_) {
      emit(const CarouselError("Failed to fetch carousel data"));
    }
  }
}
