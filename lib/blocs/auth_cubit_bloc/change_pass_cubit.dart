import 'package:bloc/bloc.dart';
import 'package:kltn_mobile/blocs/auth_cubit_bloc/change_pass_state.dart';
import 'package:kltn_mobile/blocs/repository/repository.dart';
import '../../models/user_changepass.dart';

class ChangePassCubit extends Cubit<ChangePassState> {
  final APIRepository _apiRepository;

  ChangePassCubit(this._apiRepository) : super(ChangePassInitial());

  void errorEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(email)) {
      emit(EmailError('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(ChangePassInitial());
    }
  }

  Future<void> accept(String email) async {
    emit(ChangePassLoading());
    try {
      UserChangePass? userChangePass = await _apiRepository.changePass(email);
      // ignore: unnecessary_null_comparison
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
