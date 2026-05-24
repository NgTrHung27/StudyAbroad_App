import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';

class ThemeSettingState extends Equatable {
  const ThemeSettingState({this.themeMode = ThemeMode.light});

  final ThemeMode themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  Brightness get brightness =>
      themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;

  Color get scaffoldBackgroundColor =>
      themeMode == ThemeMode.dark ? AppColor.scafflodBgColorDark : Colors.white;

  ThemeSettingState copyWith({ThemeMode? themeMode}) => ThemeSettingState(
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  List<Object?> get props => [themeMode];
}
