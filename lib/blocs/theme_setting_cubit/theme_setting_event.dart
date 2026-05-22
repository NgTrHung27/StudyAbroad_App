import 'package:equatable/equatable.dart';

abstract class ThemeSettingEvent extends Equatable {
  const ThemeSettingEvent();

  @override
  List<Object?> get props => [];
}

class LoadThemeEvent extends ThemeSettingEvent {}

class ToggleThemeEvent extends ThemeSettingEvent {}
