import 'package:bloc/bloc.dart';
import 'change_pass_event.dart';
import 'change_pass_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/repository/repository.dart';
import 'package:study_abroad_cemc_mobile/models/user_changepass.dart';

class ChangePassBloc extends Bloc<ChangePassEvent, ChangePassState> {
  final APIRepository _apiRepository;

  ChangePassBloc(this._apiRepository) : super(ChangePassInitial()) {
    on<ChangePassCheckEmailEvent>(_onCheckEmail);
    on<ChangePassSubmitEvent>(_onSubmit);
  }

  void _onCheckEmail(
      ChangePassCheckEmailEvent event, Emitter<ChangePassState> emit) {
    String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(event.email)) {
      emit(ChangePassEmailError('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(ChangePassInitial());
    }
  }

  Future<void> _onSubmit(
      ChangePassSubmitEvent event, Emitter<ChangePassState> emit) async {
    emit(ChangePassLoading());
    try {
      UserChangePass? userChangePass =
          await _apiRepository.changePass(event.email);
      if (userChangePass != null && userChangePass.error == null) {
        emit(ChangePassSuccess(userChangePass));
      } else {
        emit(ChangePassFailure(
            userChangePass?.error ?? 'Failed to reset password'));
      }
    } catch (e) {
      emit(ChangePassFailure(e.toString()));
    }
  }
}
