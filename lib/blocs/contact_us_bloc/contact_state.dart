import '../../models/schools.dart';
import '../../screens/home/contact_us.dart';

abstract class ContactUsState {}

class ContactInitialState extends ContactUsState {}

class ContactLoadingState extends ContactUsState {}

class ContactErrorTitleErrorState extends ContactUsState {
  final String error;
  ContactErrorTitleErrorState(this.error);
}

class ContactLoadedNamedSchoolState extends ContactUsState {
  final List<Schools> school;
  ContactLoadedNamedSchoolState(this.school);
}

class ContactErrorNamedSchoolState extends ContactUsState {
  final String error;
  ContactErrorNamedSchoolState(this.error);
}

class ContactSuccessState extends ContactUsState {
  final ContactUs contactUs;
  ContactSuccessState(this.contactUs);
}

//Error API
class ContactErrorState extends ContactUsState {
  final String error;
  ContactErrorState(this.error);
}

//Email
class ContactErrorEmailState extends ContactUsState {
  final String error;
  ContactErrorEmailState(this.error);
}
