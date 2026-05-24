import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<SetThemeModeEvent>(_onSetThemeMode);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  void _onSetThemeMode(SetThemeModeEvent event, Emitter<ThemeState> emit) {
    ThemeMode mode;
    switch (event.themeModeIndex) {
      case 0:
        mode = ThemeMode.light;
        break;
      case 1:
        mode = ThemeMode.dark;
        break;
      case 2:
      default:
        mode = ThemeMode.system;
    }
    emit(ThemeState(themeMode: mode));
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final newMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState(themeMode: newMode));
  }
}
