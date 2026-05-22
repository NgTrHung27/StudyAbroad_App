// FILE: AUTH_DATA_NOTIFY.DART
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

// auth_data_notify.dart
class UserAuthProvider with ChangeNotifier {
  UserAuthLogin? _userAuthLogin;

  UserAuthLogin? get userAuthLogin => _userAuthLogin;

  Future<void> setUserAuthLogin(UserAuthLogin? userAuthLogin) async {
    final logindata = await SharedPreferences.getInstance();
    final userString = logindata.getString('user');
    if (userString != null) {
      try {
        _userAuthLogin = UserAuthLogin.fromJson(jsonDecode(userString));
        notifyListeners();
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      _userAuthLogin = null;
      notifyListeners();
    }
  }
}
