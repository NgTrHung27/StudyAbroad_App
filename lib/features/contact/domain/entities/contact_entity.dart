import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String? name;
  final String? email;
  final String? title;
  final String? phone;
  final String? message;
  final String? schoolId;

  const ContactEntity({
    this.name,
    this.email,
    this.title,
    this.phone,
    this.message,
    this.schoolId,
  });

  @override
  List<Object?> get props => [name, email, title, phone, message, schoolId];
}
