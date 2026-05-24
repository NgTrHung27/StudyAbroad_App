import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/failures/auth_failures.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  LoginBloc({
    LoginUseCase? loginUseCase,
    LogoutUseCase? logoutUseCase,
    GetCurrentUserUseCase? getCurrentUserUseCase,
  })  : loginUseCase = loginUseCase ?? getIt<LoginUseCase>(),
        logoutUseCase = logoutUseCase ?? getIt<LogoutUseCase>(),
        getCurrentUserUseCase = getCurrentUserUseCase ?? getIt<GetCurrentUserUseCase>(),
        super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) {
        if (failure is NetworkErrorFailure) {
          emit(const LoginFailure(
            message: 'No internet connection. Please check your network.',
            isNetworkError: true,
          ));
        } else if (failure is InvalidCredentialsFailure) {
          emit(const LoginFailure(message: 'Invalid email or password'));
        } else {
          emit(LoginFailure(message: failure.message));
        }
      },
      (user) => emit(LoginSuccess(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(LoginFailure(message: failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<LoginState> emit,
  ) async {
    emit(AuthCheckLoading());

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) => emit(LoginInitial()),
      (user) => emit(AuthCheckSuccess(user)),
    );
  }
}
