import 'package:equatable/equatable.dart';

abstract class ProfileStatusEvent extends Equatable {
  const ProfileStatusEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileStatusEvent extends ProfileStatusEvent {
  final String status;
  const UpdateProfileStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}
