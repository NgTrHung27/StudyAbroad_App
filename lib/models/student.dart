class Student {
  School? school;
  ProgramWrapper? program;

  Student({
    this.school,
    this.program,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      school: json['school'] != null ? School.fromJson(json['school']) : null,
      program: json['program'] != null
          ? ProgramWrapper.fromJson(json['program'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school': school?.toJson(),
      'program': program?.toJson(),
    };
  }
}

class School {
  String? name;

  School({this.name});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class ProgramWrapper {
  Program? program;

  ProgramWrapper({this.program});

  factory ProgramWrapper.fromJson(Map<String, dynamic> json) {
    return ProgramWrapper(
      program:
          json['program'] != null ? Program.fromJson(json['program']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'program': program?.toJson(),
    };
  }
}

class Program {
  String? name;

  Program({this.name});

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
