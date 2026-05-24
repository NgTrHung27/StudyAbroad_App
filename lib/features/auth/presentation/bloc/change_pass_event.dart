part of 'change_pass_bloc.dart';

abstract class ChangePassEvent extends Equatable {
  const ChangePassEvent();

  @override
  List<Object?> get props => [];
}

class ChangePassCheckEmailEvent extends ChangePassEvent {
  final String email;
  const ChangePassCheckEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class ChangePassSubmitEvent extends ChangePassEvent {
  final String email;
  const ChangePassSubmitEvent(this.email);

  @override
  List<Object?> get props => [email];
}
