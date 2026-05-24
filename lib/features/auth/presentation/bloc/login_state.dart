part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserEntity user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String message;
  final bool isNetworkError;

  const LoginFailure({
    required this.message,
    this.isNetworkError = false,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}

class LogoutSuccess extends LoginState {}

class AuthCheckLoading extends LoginState {}

class AuthCheckSuccess extends LoginState {
  final UserEntity? user;

  const AuthCheckSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
