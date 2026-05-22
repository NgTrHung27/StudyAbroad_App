import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/login_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/login_event.dart';
import 'package:study_abroad_cemc_mobile/models/news.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});
}

abstract class BasePageState<T extends BasePage> extends State<T> {
  UserAuthLogin? userAuth;
  bool isLoggedIn = false;
  List<NewsList> newsData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserAuth();
  }

  Future<void> _loadUserAuth() async {
    context.read<LoginBloc>().add(CheckLoginStatusEvent());
    final logindata = await SharedPreferences.getInstance();
    print('logindata  ${logindata.toString()}');
    userAuth =
        UserAuthLogin.fromJson(jsonDecode(logindata.getString('user') ?? '{}'));
  }
}
