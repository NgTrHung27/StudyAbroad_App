import 'package:equatable/equatable.dart';

abstract class ForgotPassEvent extends Equatable {
  const ForgotPassEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPassCheckEmailEvent extends ForgotPassEvent {
  final String email;
  const ForgotPassCheckEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotPassSubmitEvent extends ForgotPassEvent {
  final String email;
  const ForgotPassSubmitEvent(this.email);

  @override
  List<Object?> get props => [email];
}
