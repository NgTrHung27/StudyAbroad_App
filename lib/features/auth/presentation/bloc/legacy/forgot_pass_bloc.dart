import 'package:bloc/bloc.dart';
import 'forgot_pass_event.dart';
import 'forgot_pass_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/repository/repository.dart';
import 'package:study_abroad_cemc_mobile/models/user_forgot.dart';

class ForgotPassBloc extends Bloc<ForgotPassEvent, ForgotPassState> {
  final APIRepository _apiRepository;

  ForgotPassBloc(this._apiRepository) : super(ForgotPassInitial()) {
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
      emit(ForgotPassEmailError('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(ForgotPassInitial());
    }
  }

  Future<void> _onSubmit(
      ForgotPassSubmitEvent event, Emitter<ForgotPassState> emit) async {
    emit(ForgotPassLoading());
    try {
      UserForgotpass? userForgotpass =
          await _apiRepository.forgotPass(event.email);
      if (userForgotpass != null && userForgotpass.error == null) {
        emit(ForgotPassSuccess(userForgotpass));
      } else {
        emit(ForgotPassFailure(
            userForgotpass?.error ?? 'Failed to reset password'));
      }
    } catch (e) {
      emit(ForgotPassFailure(e.toString()));
    }
  }
}
