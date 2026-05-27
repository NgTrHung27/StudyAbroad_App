// To parse this JSON data, do
//
//     final userAuthLogin = userAuthLoginFromJson(jsonString);

import 'dart:convert';

UserAuthLogin userAuthLoginFromJson(String str) =>
    UserAuthLogin.fromJson(json.decode(str));

String userAuthLoginToJson(UserAuthLogin data) => json.encode(data.toJson());

class UserAuthLogin {
  String id;
  String email;
  String password;
  DateTime emailVerified;
  String? name;
  DateTime dob;
  String phoneNumber;
  Student? student;
  bool isLocked;
  String? error;
  String token;

  UserAuthLogin({
    required this.id,
    required this.email,
    required this.password,
    required this.emailVerified,
    required this.name,
    required this.dob,
    required this.phoneNumber,
    this.student,
    required this.isLocked,
    this.error,
    required this.token,
  });

  UserAuthLogin copyWith({
    String? id,
    String? email,
    String? password,
    DateTime? emailVerified,
    String? name,
    DateTime? dob,
    String? phoneNumber,
    Student? student,
    bool? isLocked,
    String? error,
    String? token,
  }) =>
      UserAuthLogin(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        emailVerified: emailVerified ?? this.emailVerified,
        name: name ?? this.name,
        dob: dob ?? this.dob,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        student: student ?? this.student,
        isLocked: isLocked ?? this.isLocked,
        error: error ?? this.error,
        token: token ?? this.token,
      );

  factory UserAuthLogin.fromJson(Map<String, dynamic> json) => UserAuthLogin(
        id: json["id"] ?? '',
        email: json["email"] ?? '',
        password: json["password"] ?? '',
        emailVerified: json["emailVerified"] != null
            ? DateTime.parse(json["emailVerified"])
            : DateTime.now(),
        name: json["name"],
        dob: json["dob"] != null ? DateTime.parse(json["dob"]) : DateTime.now(),
        phoneNumber: json["phoneNumber"] ?? '',
        student:
            json["student"] != null ? Student.fromJson(json["student"]) : null,
        isLocked: json["isLocked"] ?? false,
        token: json["token"] ?? '',
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "emailVerified": emailVerified.toIso8601String(),
        "name": name,
        "dob": dob.toIso8601String(),
        "phoneNumber": phoneNumber,
        "student": student?.toJson(),
        "isLocked": isLocked,
        "error": error,
        "token": token,
      };
}

class Student {
  String id;
  String? studentCode;
  List<StudentSchoolScholarship>? scholarship;
  List<Tuition>? tuitions;
  String status;
  School school;
  List<Requirement>? requirements;
  StudentProgram? program;

  // Constructor
  Student({
    required this.id,
    this.studentCode,
    this.scholarship,
    this.tuitions,
    required this.status,
    required this.school,
    this.requirements,
    this.program,
  });

  // Constructor mặc định nếu bạn cần tạo đối tượng rỗng
  Student.empty()
      : id = '',
        // scholarship = [],
        status = '',
        school = School.empty(),
        program = StudentProgram.empty();

  Student copyWith({
    String? id,
    String? studentCode,
    List<StudentSchoolScholarship>? scholarship,
    List<Tuition>? tuitions,
    String? status,
    School? school,
    List<Requirement>? requirements,
    StudentProgram? program,
  }) =>
      Student(
        id: id ?? this.id,
        studentCode: studentCode ?? this.studentCode,
        scholarship: scholarship ?? this.scholarship,
        tuitions: tuitions ?? this.tuitions,
        status: status ?? this.status,
        school: school ?? this.school,
        requirements: requirements ?? this.requirements,
        program: program ?? this.program,
      );

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"] ?? '',
        studentCode: json["studentCode"],
        scholarship: json["scholarship"] != null
            ? List<StudentSchoolScholarship>.from(json["scholarship"]
                .map((x) => StudentSchoolScholarship.fromJson(x)))
            : [],
        tuitions: json["tuitions"] != null
            ? List<Tuition>.from(
                json["tuitions"].map((x) => Tuition.fromJson(x)))
            : [],
        status: json["status"] ?? '',
        school: json["school"] != null
            ? School.fromJson(json["school"])
            : School.empty(),
        requirements: json["requirements"] != null
            ? List<Requirement>.from(
                json["requirements"].map((x) => Requirement.fromJson(x)))
            : [],
        program: json["program"] != null
            ? StudentProgram.fromJson(json["program"])
            : StudentProgram.empty(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "studentCode": studentCode,
        "scholarship": List<dynamic>.from(scholarship!.map((x) => x.toJson())),
        "tuitions": List<dynamic>.from(tuitions!.map((x) => x.toJson())),
        "status": status,
        "school": school.toJson(),
        "requirements":
            List<dynamic>.from(requirements!.map((x) => x.toJson())),
        "program": program?.toJson(),
      };
}

class School {
  String id;
  String name;
  String logo;
  String background;

  // Constructor
  School({
    required this.id,
    required this.name,
    required this.logo,
    required this.background,
  });

  // Constructor mặc định cho School rỗng
  School.empty()
      : id = '',
        name = '',
        logo = '',
        background = '';

  School copyWith({
    String? id,
    String? name,
    String? logo,
    String? background,
  }) =>
      School(
        id: id ?? this.id,
        name: name ?? this.name,
        logo: logo ?? this.logo,
        background: background ?? this.background,
      );

  factory School.fromJson(Map<String, dynamic> json) => School(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        logo: json["logo"] ?? '',
        background: json["background"] ?? json["image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
        "background": background,
      };
}

class StudentProgram {
  ProgramProgram program;
  List<Score>? scores;

  // Constructor
  StudentProgram({
    required this.program,
    this.scores,
  });

  // Constructor mặc định cho StudentProgram rỗng
  StudentProgram.empty() : program = ProgramProgram.empty();

  StudentProgram copyWith({
    ProgramProgram? program,
    List<Score>? scores,
  }) =>
      StudentProgram(
        program: program ?? this.program,
        scores: scores ?? this.scores,
      );

  factory StudentProgram.fromJson(Map<String, dynamic> json) => StudentProgram(
        program: json["program"] != null ? ProgramProgram.fromJson(json["program"]) : ProgramProgram.empty(),
        scores: json["scores"] != null ? List<Score>.from(json["scores"].map((x) => Score.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "program": program.toJson(),
        "scores": List<dynamic>.from(scores!.map((x) => x.toJson())),
      };
}

class ProgramProgram {
  String name;

  // Constructor
  ProgramProgram({
    required this.name,
  });

  // Constructor mặc định cho ProgramProgram rỗng
  ProgramProgram.empty() : name = '';

  ProgramProgram copyWith({
    String? name,
  }) =>
      ProgramProgram(
        name: name ?? this.name,
      );

  factory ProgramProgram.fromJson(Map<String, dynamic> json) => ProgramProgram(
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Score {
  String title;
  String semester;
  String year;
  List<Subject> subjects;

  Score({
    required this.title,
    required this.semester,
    required this.year,
    required this.subjects,
  });

  Score copyWith({
    String? title,
    String? semester,
    String? year,
    List<Subject>? subjects,
  }) =>
      Score(
        title: title ?? this.title,
        semester: semester ?? this.semester,
        year: year ?? this.year,
        subjects: subjects ?? this.subjects,
      );

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        title: json["title"] ?? '',
        semester: json["semester"] ?? '',
        year: json["year"] ?? '',
        subjects: json["subjects"] != null ? List<Subject>.from(
            json["subjects"].map((x) => Subject.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "semester": semester,
        "year": year,
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
      };
}

class Subject {
  String name;
  double score;

  Subject({
    required this.name,
    required this.score,
  });

  Subject copyWith({
    String? name,
    double? score,
  }) =>
      Subject(
        name: name ?? this.name,
        score: score ?? this.score,
      );

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        name: json["name"] ?? '',
        score: json["score"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "score": score,
      };
}

class Requirement {
  String id;
  String title;
  List<StudentRequirementImage>? images;
  List<Reply>? replies;
  String status;
  String? description;

  Requirement({
    required this.id,
    required this.title,
    this.images,
    this.replies,
    required this.status,
    this.description,
  });

  Requirement copyWith({
    String? id,
    String? title,
    List<StudentRequirementImage>? images,
    List<Reply>? replies,
    String? status,
    String? description,
  }) =>
      Requirement(
        id: id ?? this.id,
        title: title ?? this.title,
        images: images ?? this.images,
        replies: replies ?? this.replies,
        status: status ?? this.status,
        description: description ?? this.description,
      );

  factory Requirement.fromJson(Map<String, dynamic> json) => Requirement(
        id: json["id"] ?? '',
        title: json["title"] ?? '',
        images: json["images"] != null
            ? List<StudentRequirementImage>.from(
                json["images"].map((x) => StudentRequirementImage.fromJson(x)))
            : [],
        replies: json["replies"] != null
            ? List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x)))
            : [],
        status: json["status"] ?? '',
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
        "replies": List<dynamic>.from(replies!.map((x) => x.toJson())),
        "status": status,
        "description": description,
      };
}

class StudentRequirementImage {
  String? id;

  String? url;

  String? requirementId;

  StudentRequirementImage({
    this.id,
    this.url,
    this.requirementId,
  });

  factory StudentRequirementImage.fromJson(Map<String, dynamic> json) =>
      StudentRequirementImage(
        id: json["id"],
        url: json["url"],
        requirementId: json["requirementId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "requirementId": requirementId,
      };
}

class Reply {
  String message;
  String senderName;
  DateTime createdAt;

  Reply({
    required this.message,
    required this.senderName,
    required this.createdAt,
  });

  Reply copyWith({
    String? message,
    String? senderName,
    DateTime? createdAt,
  }) =>
      Reply(
        message: message ?? this.message,
        senderName: senderName ?? this.senderName,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        message: json["message"] ?? '',
        senderName: json["senderName"] ?? '',
        createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "senderName": senderName,
        "createdAt": createdAt.toIso8601String(),
      };
}

class StudentSchoolScholarship {
  String status;
  String? description;
  SchoolScholarship? scholarship; // Corrected field name

  StudentSchoolScholarship({
    required this.status,
    this.description,
    this.scholarship,
  });

  StudentSchoolScholarship copyWith({
    String? status,
    String? description,
    SchoolScholarship? scholarship,
  }) =>
      StudentSchoolScholarship(
        status: status ?? this.status,
        description: description ?? this.description,
        scholarship: scholarship ?? this.scholarship,
      );

  factory StudentSchoolScholarship.fromJson(Map<String, dynamic> json) =>
      StudentSchoolScholarship(
        status: json["status"] ?? '',
        description: json["description"],
        scholarship: json["scholarship"] != null
            ? SchoolScholarship.fromJson(json["scholarship"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "description": description,
        "scholarship": scholarship?.toJson(),
      };
}

class SchoolScholarship {
  String name;
  String cover;
  List<SchoolScholarshipImage>? images;
  String description;

  SchoolScholarship({
    required this.name,
    required this.cover,
    this.images,
    required this.description,
  });

  SchoolScholarship copyWith({
    String? name,
    String? cover,
    List<SchoolScholarshipImage>? images,
    String? description,
  }) =>
      SchoolScholarship(
        name: name ?? this.name,
        cover: cover ?? this.cover,
        images: images ?? this.images,
        description: description ?? this.description,
      );

  factory SchoolScholarship.fromJson(Map<String, dynamic> json) =>
      SchoolScholarship(
        name: json["name"] ?? '',
        cover: json["cover"] ?? '',
        images: json["images"] != null ? List<SchoolScholarshipImage>.from(
            json["images"].map((x) => SchoolScholarshipImage.fromJson(x))) : [],
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "cover": cover,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
        "description": description,
      };
}

class SchoolScholarshipImage {
  String id;

  String url;

  String scholarshipId;

  SchoolScholarshipImage({
    required this.id,
    required this.url,
    required this.scholarshipId,
  });

  factory SchoolScholarshipImage.fromJson(Map<String, dynamic> json) =>
      SchoolScholarshipImage(
        id: json["id"] ?? '',
        url: json["url"] ?? '',
        scholarshipId: json["scholarshipId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "scholarshipId": scholarshipId,
      };
}

class Tuition {
  String? status;
  dynamic amount;
  String? description;
  DateTime? dueAt;

  Tuition({
    this.status,
    this.amount,
    this.description,
    this.dueAt,
  });

  Tuition copyWith({
    String? status,
    double? amount,
    String? description,
    DateTime? dueAt,
  }) =>
      Tuition(
        status: status ?? this.status,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        dueAt: dueAt ?? this.dueAt,
      );

  factory Tuition.fromJson(Map<String, dynamic> json) => Tuition(
        status: json["status"],
        amount: json["amount"],
        description: json["description"],
        dueAt: json["dueAt"] != null ? DateTime.parse(json["dueAt"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "amount": amount,
        "description": description,
        "dueAt": dueAt?.toIso8601String(),
      };
}
