import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kltn_mobile/blocs/auth_cubit_bloc/login_cubit.dart';
import 'package:kltn_mobile/blocs/lang_cubit/language_bloc.dart';
import 'package:kltn_mobile/models/news.dart';
import 'package:kltn_mobile/models/user_login.dart';
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
    _loadLanguage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserAuth();
  }

  Future<void> _loadUserAuth() async {
    context.read<LoginCubit>().checkLoginStatus();
    final logindata = await SharedPreferences.getInstance();
    print('logindata  ${logindata.toString()}');
    userAuth =
        UserAuthLogin.fromJson(jsonDecode(logindata.getString('user') ?? '{}'));
  }

  Future<void> _loadLanguage() async {
    final languageCode =
        await context.read<LanguageBloc>().getCurrentLanguageCode();
    switch (languageCode) {
      case 'en':
        // ignore: use_build_context_synchronously
        context.read<LanguageBloc>().add(LanguageEvent.setEnglish);
        break;
      case 'ko':
        // ignore: use_build_context_synchronously
        context.read<LanguageBloc>().add(LanguageEvent.setKorean);
        break;
      case 'vi':
        // ignore: use_build_context_synchronously
        context.read<LanguageBloc>().add(LanguageEvent.setVietnamese);
        break;
    }
  }
}
