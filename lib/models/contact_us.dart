import 'package:study_abroad_cemc_mobile/models/enum.dart';

class ContactUs {
  String name;
  String email;
  TitleForm? title; // Giả sử TitleForm là kiểu tùy chỉnh
  String phone;
  String message;
  String? schoolId;
  String? error;

  ContactUs({
    required this.name,
    required this.email,
    required this.title,
    required this.phone,
    required this.message,
    this.schoolId,
    this.error,
  });

  // Phương thức fromJson
  factory ContactUs.fromJson(Map<String, dynamic> json) {
    return ContactUs(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      title: json['title'] != null ? _parseTitle(json['title']) : null,
      phone: json['phone'] ?? '',
      message: json['message'] ?? '',
      schoolId: json['schoolId'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "title": title?.toString(),
        "phone": phone,
        "message": message,
        "schoolId": schoolId,
        "error": error,
      };

  static TitleForm? _parseTitle(dynamic titleString) {
    if (titleString is String) {
      switch (titleString.toUpperCase()) {
        case 'FEEDBACK':
          return TitleForm.FEEDBACK;
        case 'SYSTEM':
          return TitleForm.SYSTEM;
        case 'REFUND':
          return TitleForm.REFUND;
        case 'BILLING':
          return TitleForm.BILLING;
        case 'SUBSCRIPTION':
          return TitleForm.SUBSCRIPTION;
        case 'SCHOLARSHIP':
          return TitleForm.SCHOLARSHIP;
        case 'PROCEDURE':
          return TitleForm.PROCEDURE;
        default:
          return null;
      }
    }
    return null;
  }
}
