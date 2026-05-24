import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:equatable/equatable.dart';

part 'change_pass_event.dart';
part 'change_pass_state.dart';

class ChangePassBloc extends Bloc<ChangePassEvent, ChangePassState> {
  final AuthRepository authRepository;

  ChangePassBloc({
    AuthRepository? authRepository,
  })  : authRepository = authRepository ?? getIt<AuthRepository>(),
        super(ChangePassInitial()) {
    on<ChangePassCheckEmailEvent>(_onCheckEmail);
    on<ChangePassSubmitEvent>(_onSubmit);
  }

  void _onCheckEmail(
      ChangePassCheckEmailEvent event, Emitter<ChangePassState> emit) {
    String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(event.email)) {
      emit(const ChangePassEmailError('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(ChangePassInitial());
    }
  }

  Future<void> _onSubmit(
      ChangePassSubmitEvent event, Emitter<ChangePassState> emit) async {
    emit(ChangePassLoading());

    final result = await authRepository.changePassword(
      email: event.email,
      currentPassword: '',
      newPassword: '',
    );

    result.fold(
      (failure) {
        if (failure is NetworkErrorFailure) {
          emit(const ChangePassFailure(
              'No internet connection. Please check your network.'));
        } else {
          emit(ChangePassFailure(failure.message));
        }
      },
      (_) => emit(ChangePassSuccess()),
    );
  }

  Future<void> accept(String email) async {
    add(ChangePassSubmitEvent(email));
  }

  void errorEmail(String email) {
    add(ChangePassCheckEmailEvent(email));
  }
}
