part of 'change_pass_bloc.dart';

abstract class ChangePassState extends Equatable {
  const ChangePassState();

  @override
  List<Object?> get props => [];
}

class ChangePassInitial extends ChangePassState {}

class ChangePassLoading extends ChangePassState {}

class ChangePassEmailError extends ChangePassState {
  final String message;
  const ChangePassEmailError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChangePassSuccess extends ChangePassState {}

class ChangePassFailure extends ChangePassState {
  final String message;
  const ChangePassFailure(this.message);

  @override
  List<Object?> get props => [message];
}
