import 'package:study_abroad_cemc_mobile/models/user_changepass.dart';

abstract class ChangePassState {}

class ChangePassInitial extends ChangePassState {}

class ChangePassLoading extends ChangePassState {}

class ChangePassSuccess extends ChangePassState {
  final UserChangePass userChangePass;

  ChangePassSuccess(this.userChangePass);
}

class ChangePassFailure extends ChangePassState {
  final String error;

  ChangePassFailure(this.error);
}

class ChangePassEmailError extends ChangePassState {
  final String error;

  ChangePassEmailError(this.error);
}
