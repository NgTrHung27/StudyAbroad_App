import 'package:bloc/bloc.dart';
import 'package:kltn_mobile/blocs/repository/repository.dart';
import 'package:kltn_mobile/models/user_forgot.dart';
import 'package:meta/meta.dart';


part 'forgot_pass_state.dart';

class ForgotPassCubit extends Cubit<ForgotPassState> {
  final APIRepository _apiRepository;

  ForgotPassCubit(this._apiRepository) : super(ForgotPassInitial());

  void errorEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(email)) {
      emit(EmailError('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(ForgotPassInitial());
    }
  }

  Future<void> accept(String email) async {
    emit(ForgotPassLoading());
    try {
      UserForgotpass? userForgotpass = await _apiRepository.forgotPass(email);
      // ignore: unnecessary_null_comparison
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
