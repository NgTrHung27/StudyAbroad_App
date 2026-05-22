import 'package:equatable/equatable.dart';
import '../../models/enum.dart';

abstract class ContactUsEvent extends Equatable {
  const ContactUsEvent();

  @override
  List<Object?> get props => [];
}

class ContactCheckTitleEvent extends ContactUsEvent {
  final TitleForm? titleForm;
  const ContactCheckTitleEvent(this.titleForm);

  @override
  List<Object?> get props => [titleForm];
}

class ContactCheckEmailEvent extends ContactUsEvent {
  final String email;
  const ContactCheckEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class ContactGetSchoolsEvent extends ContactUsEvent {}

class ContactSendFormEvent extends ContactUsEvent {
  final String fullName;
  final String email;
  final TitleForm valueTitle;
  final String phone;
  final String message;
  final String? selectedSchool;

  const ContactSendFormEvent({
    required this.fullName,
    required this.email,
    required this.valueTitle,
    required this.phone,
    required this.message,
    this.selectedSchool,
  });

  @override
  List<Object?> get props => [fullName, email, valueTitle, phone, message, selectedSchool];
}
