import 'package:meta/meta.dart';

@immutable
abstract class ProfileStatusState {}

class ProfileStatusInitial extends ProfileStatusState {}

class ProfileStatusLoaded extends ProfileStatusState {
  final String status;
  final int currentStep;

  ProfileStatusLoaded({required this.status, required this.currentStep});
}
