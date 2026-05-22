import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:study_abroad_cemc_mobile/features/auth/data/models/user_model.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCachedUserRequested extends AuthEvent {
  const AuthCachedUserRequested();
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  final AuthFailure? failure;

  const AuthError(this.message, [this.failure]);

  @override
  List<Object?> get props => [message, failure];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCachedUserRequested>(_onCachedUserRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _repository.isLoggedIn();

    result.fold(
      (failure) => emit(AuthError(failure.message, failure)),
      (isLoggedIn) async {
        if (isLoggedIn) {
          final userResult = await _repository.getCachedUser();
          userResult.fold(
            (failure) => emit(const AuthUnauthenticated()),
            (user) {
              if (user != null) {
                emit(AuthAuthenticated(UserModel(
                  id: user.id,
                  email: user.email,
                  name: user.name,
                  dob: user.dob,
                  phoneNumber: user.phoneNumber,
                  image: user.image,
                  isLocked: user.isLocked,
                  token: user.token,
                  student: user.student,
                )));
              } else {
                emit(const AuthUnauthenticated());
              }
            },
          );
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _repository.login(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message, failure)),
      (user) => emit(AuthAuthenticated(UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        dob: user.dob,
        phoneNumber: user.phoneNumber,
        image: user.image,
        isLocked: user.isLocked,
        token: user.token,
        student: user.student,
      ))),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _repository.logout();

    result.fold(
      (failure) => emit(AuthError(failure.message, failure)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onCachedUserRequested(
    AuthCachedUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _repository.getCachedUser();

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(UserModel(
            id: user.id,
            email: user.email,
            name: user.name,
            dob: user.dob,
            phoneNumber: user.phoneNumber,
            image: user.image,
            isLocked: user.isLocked,
            token: user.token,
            student: user.student,
          )));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }
}
