import 'package:bloc/bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';
import '../repository/repository.dart';
import '../../models/schools.dart';
import '../../models/enum.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/contact_us.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  final APIRepository authRepo;

  ContactUsBloc(this.authRepo) : super(ContactInitialState()) {
    on<ContactCheckTitleEvent>(_onCheckTitle);
    on<ContactCheckEmailEvent>(_onCheckEmail);
    on<ContactGetSchoolsEvent>(_onGetSchools);
    on<ContactSendFormEvent>(_onSendForm);
  }

  Future<void> getSchools() async {
    add(ContactGetSchoolsEvent());
  }

  Future<void> sendForm(
    String fullName,
    String email,
    TitleForm title,
    String phone,
    String message,
    String? selectedSchool,
  ) async {
    add(ContactSendFormEvent(
      fullName: fullName,
      email: email,
      valueTitle: title,
      phone: phone,
      message: message,
      selectedSchool: selectedSchool,
    ));
  }

  void checkEmail(String email) {
    add(ContactCheckEmailEvent(email));
  }

  void _onCheckTitle(
      ContactCheckTitleEvent event, Emitter<ContactUsState> emit) {
    if (event.titleForm == null) {
      emit(ContactErrorTitleErrorState('Please choose a title'));
    } else {
      emit(ContactInitialState());
    }
  }

  void _onCheckEmail(
      ContactCheckEmailEvent event, Emitter<ContactUsState> emit) {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(event.email)) {
      emit(ContactErrorEmailState('Please enter a valid email'));
    } else {
      emit(ContactInitialState());
    }
  }

  Future<void> _onGetSchools(
      ContactGetSchoolsEvent event, Emitter<ContactUsState> emit) async {
    emit(ContactLoadingState());
    try {
      List<Schools> schools = await authRepo.fetchSchools();
      emit(ContactLoadedNamedSchoolState(schools));
    } catch (ex) {
      emit(ContactErrorNamedSchoolState(ex.toString()));
    }
  }

  Future<void> _onSendForm(
      ContactSendFormEvent event, Emitter<ContactUsState> emit) async {
    emit(ContactLoadingState());
    try {
      ContactUs? contactUs = await authRepo.contactUs(
        event.fullName,
        event.email,
        event.valueTitle.toString().split('.').last.toUpperCase(),
        event.phone,
        event.message,
        event.selectedSchool ?? '',
      );

      if (contactUs != null) {
        emit(ContactSuccessState(contactUs));
      } else {
        emit(ContactErrorState('An error occurred while sending the form.'));
      }
    } catch (e) {
      emit(ContactErrorState(e.toString()));
    }
  }
}
