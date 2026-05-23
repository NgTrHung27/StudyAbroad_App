import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage helper using SharedPreferences
class LocalStorage {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences - must be called before using
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError(
          'LocalStorage not initialized. Call LocalStorage.init() first.');
    }
    return _prefs!;
  }

  // String operations
  static Future<bool> setString(String key, String value) async {
    return prefs.setString(key, value);
  }

  static String? getString(String key) {
    return prefs.getString(key);
  }

  // Bool operations
  static Future<bool> setBool(String key, bool value) async {
    return prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return prefs.getBool(key);
  }

  // Int operations
  static Future<bool> setInt(String key, int value) async {
    return prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return prefs.getInt(key);
  }

  // Double operations
  static Future<bool> setDouble(String key, double value) async {
    return prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  // JSON operations - store objects as JSON strings
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return prefs.setString(key, jsonEncode(value));
  }

  static Map<String, dynamic>? getJson(String key) {
    final value = prefs.getString(key);
    if (value == null) return null;
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // List operations
  static Future<bool> setStringList(String key, List<String> value) async {
    return prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  // Remove operations
  static Future<bool> remove(String key) async {
    return prefs.remove(key);
  }

  // Check if key exists
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  // Clear all data
  static Future<bool> clear() async {
    return prefs.clear();
  }

  // Get all keys
  static Set<String> getKeys() {
    return prefs.getKeys();
  }
}

/// Storage keys - centralized key management
class StorageKeys {
  StorageKeys._();

  // Auth keys
  static const String token = 'auth_token';
  static const String user = 'user_data';
  static const String refreshToken = 'refresh_token';
  static const String isRememberMe = 'is_remember_me';
  static const String userEmail = 'user_email';
  static const String userPassword = 'user_password';

  // Theme keys
  static const String isDarkMode = 'is_dark_mode';
  static const String themeMode = 'theme_mode';

  // Locale keys
  static const String locale = 'app_locale';
  static const String languageCode = 'language_code';

  // Notification keys
  static const String fcmToken = 'fcm_token';
  static const String notificationEnabled = 'notification_enabled';

  // App state keys
  static const String onboardingCompleted = 'onboarding_completed';
  static const String lastSyncTime = 'last_sync_time';
  static const String appVersion = 'app_version';

  // Chat keys
  static const String chatClientId = 'chat_client_id';
}
