import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class CheckLoginStatusEvent extends LoginEvent {}

class AutoLoginEvent extends LoginEvent {}

class LoginRequestedEvent extends LoginEvent {
  final String email;
  final String password;
  final bool isRememberChange;

  const LoginRequestedEvent({
    required this.email,
    required this.password,
    required this.isRememberChange,
  });

  @override
  List<Object?> get props => [email, password, isRememberChange];
}

class LogoutEvent extends LoginEvent {}

class CheckLoginEmailEvent extends LoginEvent {
  final String email;
  const CheckLoginEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}
