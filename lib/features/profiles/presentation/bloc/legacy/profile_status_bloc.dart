import 'package:bloc/bloc.dart';
import 'profile_status_event.dart';
import 'profile_status_state.dart';

class ProfileStatusBloc extends Bloc<ProfileStatusEvent, ProfileStatusState> {
  ProfileStatusBloc() : super(ProfileStatusInitial()) {
    on<UpdateProfileStatusEvent>(_onUpdateStatus);
  }

  void _onUpdateStatus(
      UpdateProfileStatusEvent event, Emitter<ProfileStatusState> emit) {
    int currentStep;
    if (event.status == 'APPROVED' || event.status == 'DENIED') {
      currentStep = 2;
    } else {
      currentStep = 1;
    }
    emit(ProfileStatusLoaded(status: event.status, currentStep: currentStep));
  }
}
