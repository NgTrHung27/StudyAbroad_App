import 'package:bloc/bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_schools_usecase.dart';

import 'carousel_event.dart';
import 'carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  final GetSchoolsUseCase getSchoolsUseCase;

  CarouselBloc({
    GetSchoolsUseCase? getSchoolsUseCase,
  })  : getSchoolsUseCase = getSchoolsUseCase ?? getIt<GetSchoolsUseCase>(),
        super(CarouselInitial()) {
    on<FetchCarousel>(_onFetchCarousel);
  }

  void _onFetchCarousel(
      FetchCarousel event, Emitter<CarouselState> emit) async {
    emit(CarouselLoading());
    
    final result = await getSchoolsUseCase();

    result.fold(
      (failure) {
        final errorMsg = failure.message ?? '';
        final isNetworkError = errorMsg.contains('SocketException') ||
            errorMsg.contains('Connection refused') ||
            errorMsg.contains('Timeout') ||
            errorMsg.contains('No internet') ||
            errorMsg.contains('network');

        emit(CarouselError(
          message: isNetworkError
              ? 'Unable to connect to the server. Please check your internet connection.'
              : 'Failed to load schools. Please try again later.',
          isNetworkError: isNetworkError,
        ));
      },
      (schools) => emit(CarouselLoaded(schools)),
    );
  }
}
