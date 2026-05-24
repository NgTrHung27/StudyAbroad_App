import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:equatable/equatable.dart';

part 'forgot_pass_event.dart';
part 'forgot_pass_state.dart';

class ForgotPassBloc extends Bloc<ForgotPassEvent, ForgotPassState> {
  final AuthRepository authRepository;

  ForgotPassBloc({
    AuthRepository? authRepository,
  })  : authRepository = authRepository ?? getIt<AuthRepository>(),
        super(ForgotPassInitial()) {
    on<ForgotPassCheckEmailEvent>(_onCheckEmail);
    on<ForgotPassSubmitEvent>(_onSubmit);
  }

  Future<void> accept(String email) async {
    add(ForgotPassSubmitEvent(email));
  }

  void errorEmail(String email) {
    add(ForgotPassCheckEmailEvent(email));
  }

  void _onCheckEmail(
      ForgotPassCheckEmailEvent event, Emitter<ForgotPassState> emit) {
    String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(event.email)) {
      emit(const ForgotPassEmailError('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(ForgotPassInitial());
    }
  }

  Future<void> _onSubmit(
      ForgotPassSubmitEvent event, Emitter<ForgotPassState> emit) async {
    emit(ForgotPassLoading());

    final result = await authRepository.forgotPassword(event.email);

    result.fold(
      (failure) {
        if (failure is NetworkErrorFailure) {
          emit(const ForgotPassFailure(
              'No internet connection. Please check your network.'));
        } else {
          emit(ForgotPassFailure(failure.message));
        }
      },
      (_) => emit(ForgotPassSuccess()),
    );
  }
}
