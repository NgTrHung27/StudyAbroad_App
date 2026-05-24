import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/core/configs/injector/injector.dart';
import 'package:study_abroad_cemc_mobile/features/contact/domain/failures/contact_failures.dart';
import 'package:study_abroad_cemc_mobile/features/contact/domain/usecases/submit_contact_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/usecases/get_schools_usecase.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/schools_failures.dart';
import 'package:study_abroad_cemc_mobile/models/enum.dart';
import 'package:study_abroad_cemc_mobile/models/schools.dart';
import 'package:equatable/equatable.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  final SubmitContactUseCase submitContactUseCase;
  final GetSchoolsUseCase getSchoolsUseCase;

  ContactUsBloc({
    SubmitContactUseCase? submitContactUseCase,
    GetSchoolsUseCase? getSchoolsUseCase,
  })  : submitContactUseCase = submitContactUseCase ?? getIt<SubmitContactUseCase>(),
        getSchoolsUseCase = getSchoolsUseCase ?? getIt<GetSchoolsUseCase>(),
        super(ContactInitialState()) {
    on<ContactCheckTitleEvent>(_onCheckTitle);
    on<ContactCheckEmailEvent>(_onCheckEmail);
    on<ContactGetSchoolsEvent>(_onGetSchools);
    on<ContactSendFormEvent>(_onSendForm);
  }

  void _onCheckTitle(
      ContactCheckTitleEvent event, Emitter<ContactUsState> emit) {
    if (event.titleForm == null) {
      emit(const ContactErrorTitleErrorState('Please choose a title'));
    } else {
      emit(ContactInitialState());
    }
  }

  void _onCheckEmail(
      ContactCheckEmailEvent event, Emitter<ContactUsState> emit) {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(event.email)) {
      emit(const ContactErrorEmailState('Please enter a valid email'));
    } else {
      emit(ContactInitialState());
    }
  }

  // Helper method for backward compatibility
  void getSchools() {
    add(ContactGetSchoolsEvent());
  }

  // Helper method for backward compatibility
  void sendForm(
    String fullName,
    String email,
    TitleForm valueTitle,
    String phone,
    String message,
    String? selectedSchool,
  ) {
    add(ContactSendFormEvent(
      fullName: fullName,
      email: email,
      valueTitle: valueTitle,
      phone: phone,
      message: message,
      selectedSchool: selectedSchool,
    ));
  }

  // Helper method for backward compatibility
  void checkEmail(String email) {
    add(ContactCheckEmailEvent(email));
  }

  Future<void> _onGetSchools(
      ContactGetSchoolsEvent event, Emitter<ContactUsState> emit) async {
    emit(ContactLoadingState());

    final result = await getSchoolsUseCase();

    result.fold(
      (failure) {
        if (failure is SchoolsNetworkFailure) {
          emit(const ContactErrorNamedSchoolState(
              'No internet connection. Please check your network.'));
        } else {
          emit(ContactErrorNamedSchoolState(failure.message ?? 'Error loading schools'));
        }
      },
      (schools) => emit(ContactLoadedNamedSchoolState(
          schools.cast<Schools>())),
    );
  }

  Future<void> _onSendForm(
      ContactSendFormEvent event, Emitter<ContactUsState> emit) async {
    emit(ContactLoadingState());

    final result = await submitContactUseCase(
      name: event.fullName,
      email: event.email,
      title: event.valueTitle.toString().split('.').last.toUpperCase(),
      phone: event.phone,
      message: event.message,
      schoolId: event.selectedSchool,
    );

    result.fold(
      (failure) {
        if (failure is ContactNetworkFailure) {
          emit(const ContactErrorState(
            'No internet connection. Please check your network.',
            isNetworkError: true,
          ));
        } else {
          emit(ContactErrorState(failure.message));
        }
      },
      (_) => emit(ContactSuccessState()),
    );
  }
}
