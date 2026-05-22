import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeSettingState extends Equatable {
  const ThemeSettingState(
      {this.themeMode = ThemeMode.light});

  final ThemeMode themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  Brightness get brightness =>
      themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;

  Color get scaffoldBackgroundColor =>
      themeMode == ThemeMode.dark ? const Color(0xff1E2334) : Colors.white;

  ThemeSettingState copyWith({ThemeMode? themeMode}) => ThemeSettingState(
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  List<Object?> get props => [themeMode];
}
