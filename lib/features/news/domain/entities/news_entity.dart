import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String type;
  final String cover;
  final bool isPublished;
  final dynamic schoolId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final NewsSchoolEntity? school;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.cover,
    required this.isPublished,
    required this.schoolId,
    required this.createdAt,
    required this.updatedAt,
    this.school,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        type,
        cover,
        isPublished,
        schoolId,
        createdAt,
        updatedAt,
        school
      ];
}

class NewsSchoolEntity extends Equatable {
  final String name;

  const NewsSchoolEntity({required this.name});

  @override
  List<Object?> get props => [name];
}
