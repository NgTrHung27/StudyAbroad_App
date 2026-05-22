import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class SetThemeModeEvent extends ThemeEvent {
  final int themeModeIndex; // 0: light, 1: dark, 2: system
  const SetThemeModeEvent(this.themeModeIndex);

  @override
  List<Object?> get props => [themeModeIndex];
}

class ToggleThemeEvent extends ThemeEvent {}
