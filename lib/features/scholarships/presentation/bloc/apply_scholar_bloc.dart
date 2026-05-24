import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/data/models/apply_scholar_model.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/domain/failures/scholarship_failures.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/domain/usecases/apply_scholarship_usecase.dart';
import 'package:equatable/equatable.dart';

part 'apply_scholar_event.dart';
part 'apply_scholar_state.dart';

class ApplyScholarBloc extends Bloc<ApplyScholarEvent, ApplyScholarState> {
  final ApplyScholarshipUseCase applyScholarshipUseCase;

  ApplyScholarBloc({
    ApplyScholarshipUseCase? applyScholarshipUseCase,
  })  : applyScholarshipUseCase =
            applyScholarshipUseCase ?? getIt<ApplyScholarshipUseCase>(),
        super(ApplyScholarInitial()) {
    on<SendApplyScholarEvent>(_onSendApplyScholar);
  }

  Future<void> _onSendApplyScholar(
      SendApplyScholarEvent event, Emitter<ApplyScholarState> emit) async {
    emit(ApplyScholarLoading());

    final result = await applyScholarshipUseCase(
      url: event.url,
      studentId: event.studentId,
      scholarshipId: event.scholarshipId,
      additional: event.additional,
    );

    result.fold(
      (failure) {
        if (failure is ScholarshipNetworkFailure) {
          emit(const ApplyScholarError(
            'No internet connection. Please check your network.',
            isNetworkError: true,
          ));
        } else {
          emit(ApplyScholarError(failure.message));
        }
      },
      (applyScholarModel) {
        if (applyScholarModel.error != null) {
          emit(ApplyScholarFailure(
            applyScholarModel: applyScholarModel,
            error: applyScholarModel.error,
          ));
        } else {
          emit(ApplyScholarSuccess(applyScholarModel));
        }
      },
    );
  }
}
