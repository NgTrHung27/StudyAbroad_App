import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'theme_setting_event.dart';
import 'theme_setting_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettingBloc extends Bloc<ThemeSettingEvent, ThemeSettingState> {
  ThemeSettingBloc() : super(const ThemeSettingState()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  void loadTheme() {
    add(LoadThemeEvent());
  }

  void toggleTheme() {
    add(ToggleThemeEvent());
  }

  Future<void> _onLoadTheme(
      LoadThemeEvent event, Emitter<ThemeSettingState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(ThemeSettingState(
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    ));
  }

  Future<void> _onToggleTheme(
      ToggleThemeEvent event, Emitter<ThemeSettingState> emit) async {
    final newThemeMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeSettingState(themeMode: newThemeMode));
    _saveTheme(newThemeMode == ThemeMode.dark);
  }

  Future<void> _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }
}
