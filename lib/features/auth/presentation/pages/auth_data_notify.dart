// FILE: AUTH_DATA_NOTIFY.DART
import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';

// auth_data_notify.dart
import 'package:study_abroad_cemc_mobile/core/cache/local_storage.dart';
import 'package:study_abroad_cemc_mobile/blocs/repository/repository.dart';

class UserAuthProvider with ChangeNotifier {
  UserAuthLogin? _userAuthLogin;

  UserAuthLogin? get userAuthLogin => _userAuthLogin;

  Future<void> setUserAuthLogin(UserAuthLogin? userAuthLogin) async {
    final userJson = LocalStorage.getJson(StorageKeys.user);
    if (userJson != null) {
      try {
        _userAuthLogin = UserAuthLogin.fromJson(userJson);
        notifyListeners();
      } catch (e) {
        print('Error decoding JSON: \$e');
      }
    } else {
      _userAuthLogin = null;
      notifyListeners();
    }
  }

  Future<void> fetchFreshProfile() async {
    final password = LocalStorage.getString(StorageKeys.userPassword) ?? '';
    final repo = APIRepository();
    final freshUser = await repo.getMe(password);
    if (freshUser != null) {
      _userAuthLogin = freshUser;
      notifyListeners();
    }
  }
}
