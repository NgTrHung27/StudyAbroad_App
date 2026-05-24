part of 'forgot_pass_bloc.dart';

abstract class ForgotPassState extends Equatable {
  const ForgotPassState();

  @override
  List<Object?> get props => [];
}

class ForgotPassInitial extends ForgotPassState {}

class ForgotPassLoading extends ForgotPassState {}

class ForgotPassEmailError extends ForgotPassState {
  final String message;
  const ForgotPassEmailError(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgotPassSuccess extends ForgotPassState {}

class ForgotPassFailure extends ForgotPassState {
  final String message;
  const ForgotPassFailure(this.message);

  @override
  List<Object?> get props => [message];
}
