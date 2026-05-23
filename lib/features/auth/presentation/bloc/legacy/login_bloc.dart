import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/repository/repository.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final APIRepository _apiRepository;
  late SharedPreferences logindata;
  UserAuthLogin? userAuthLogin;

  LoginBloc(this._apiRepository)
      : super(LoginCheckSessionState(isLoggedIn: false)) {
    on<CheckLoginStatusEvent>(_onCheckLoginStatus);
    on<AutoLoginEvent>(_onAutoLogin);
    on<LoginRequestedEvent>(_onLoginRequested);
    on<LogoutEvent>(_onLogout);
    on<CheckLoginEmailEvent>(_onCheckLoginEmail);
  }

  Future<UserAuthLogin?> checkLoginStatus() async {
    logindata = await SharedPreferences.getInstance();
    final userString = logindata.getString('user');
    final token = logindata.getString('token');
    final isRemember = logindata.getBool('isRememberChange') ?? false;
    if (token != null && isRemember && userString != null) {
      userAuthLogin = UserAuthLogin.fromJson(jsonDecode(userString));
      return userAuthLogin;
    } else if (token != null && isRemember) {
      final email = logindata.getString('email');
      final password = logindata.getString('password');
      if (email != null && password != null) {
        add(LoginRequestedEvent(
            email: email, password: password, isRememberChange: true));
      }
    }
    return null;
  }

  Future<UserAuthLogin?> login(
      String email, String password, bool isRemember) async {
    add(LoginRequestedEvent(
        email: email, password: password, isRememberChange: isRemember));
    return userAuthLogin;
  }

  Future<void> _onCheckLoginStatus(
      CheckLoginStatusEvent event, Emitter<LoginState> emit) async {
    await checkLoginStatus();
  }

  Future<void> _onAutoLogin(
      AutoLoginEvent event, Emitter<LoginState> emit) async {
    final email = logindata.getString('email');
    final password = logindata.getString('password');
    final isRemember = logindata.getBool('isRememberChange') ?? false;

    if (email != null && password != null) {
      add(LoginRequestedEvent(
          email: email, password: password, isRememberChange: isRemember));
    }
  }

  Future<void> _onLoginRequested(
      LoginRequestedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      UserAuthLogin? userAuthLogin =
          await _apiRepository.login(event.email, event.password);
      if (userAuthLogin != null && userAuthLogin.error == null) {
        this.userAuthLogin = userAuthLogin;
        logindata = await SharedPreferences.getInstance();
        if (userAuthLogin.token.isEmpty) {
          userAuthLogin.token = _generateRandomToken();
        }
        if (event.isRememberChange) {
          await logindata.setString('token', userAuthLogin.token);
          await logindata.setString('email', event.email);
          await logindata.setString('password', event.password);
          await logindata.setBool('isRememberChange', event.isRememberChange);
        }
        await logindata.setString('user', jsonEncode(userAuthLogin.toJson()));

        emit(LoginSuccess(userAuthLogin));
      } else {
        final errorLogin = userAuthLogin?.error ?? 'Error';
        emit(LoginFailure(errorLogin));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<LoginState> emit) async {
    logindata = await SharedPreferences.getInstance();
    await logindata.remove('token');
    await logindata.remove('user');
    await logindata.remove('isRememberChange');
    emit(LoginInitial());
  }

  void _onCheckLoginEmail(
      CheckLoginEmailEvent event, Emitter<LoginState> emit) {
    String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(event.email)) {
      emit(LoginEmailError('Vui lòng nhập đúng định dạng email'));
    } else {
      emit(LoginInitial());
    }
  }

  String _generateRandomToken() {
    const length = 32;
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }
}
