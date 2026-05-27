// FILE: AUTH_DATA_NOTIFY.DART
import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';

// auth_data_notify.dart
import 'package:study_abroad_cemc_mobile/core/cache/local_storage.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/auth/domain/repositories/auth_repository.dart';

class UserAuthProvider with ChangeNotifier {
  UserAuthLogin? _userAuthLogin;
  bool _isFetchingProfile = false;

  UserAuthLogin? get userAuthLogin => _userAuthLogin;
  bool get isFetchingProfile => _isFetchingProfile;
  bool hasFetchedProfile = false;

  Future<void> setUserAuthLogin() async {
    final userJson = LocalStorage.getJson(StorageKeys.user);
    if (userJson != null) {
      try {
        _userAuthLogin = UserAuthLogin.fromJson(userJson);
        notifyListeners();
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      _userAuthLogin = null;
      notifyListeners();
    }
  }

  void clearUserAuthLogin() {
    _userAuthLogin = null;
    LocalStorage.remove(StorageKeys.user);
    LocalStorage.remove(StorageKeys.token);
    notifyListeners();
  }
  Future<void> fetchFreshProfile() async {
    _isFetchingProfile = true;
    hasFetchedProfile = true;
    notifyListeners();

    final token = LocalStorage.getString(StorageKeys.token);
    
    if (token == null || token.isEmpty) {
      _isFetchingProfile = false;
      notifyListeners();
      return;
    }
    
    final authRepository = getIt<AuthRepository>();
    final result = await authRepository.getCurrentProfile();
    
    result.fold(
      (failure) {
        // Handle error silently
        _isFetchingProfile = false;
        notifyListeners();
      },
      (user) async {
        await setUserAuthLogin();
        _isFetchingProfile = false;
        notifyListeners();
      },
    );
  }
}
