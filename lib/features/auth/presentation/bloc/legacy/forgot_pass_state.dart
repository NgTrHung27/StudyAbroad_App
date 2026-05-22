import 'package:meta/meta.dart';
import 'package:study_abroad_cemc_mobile/models/user_forgot.dart';

@immutable
abstract class ForgotPassState {}

class ForgotPassInitial extends ForgotPassState {}

class ForgotPassLoading extends ForgotPassState {}

class ForgotPassSuccess extends ForgotPassState {
  final UserForgotpass userForgotpass;

  ForgotPassSuccess(this.userForgotpass);
}

class ForgotPassFailure extends ForgotPassState {
  final String error;

  ForgotPassFailure(this.error);
}

class ForgotPassEmailError extends ForgotPassState {
  final String error;

  ForgotPassEmailError(this.error);
}
