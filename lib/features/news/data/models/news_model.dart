import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.id,
    required super.title,
    required super.content,
    required super.type,
    required super.cover,
    required super.isPublished,
    required super.schoolId,
    required super.createdAt,
    required super.updatedAt,
    super.school,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json["id"] ?? '',
      title: json["title"] ?? '',
      content: json["content"] ?? '',
      type: json["type"] ?? '',
      cover: json["cover"] ?? '',
      isPublished: json["isPublished"] ?? false,
      schoolId: json["schoolId"],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
      school: json["school"] != null
          ? NewsSchoolModel.fromJson(json["school"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "type": type,
        "cover": cover,
        "isPublished": isPublished,
        "schoolId": schoolId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "school": school != null ? (school as NewsSchoolModel).toJson() : null,
      };
}

class NewsSchoolModel extends NewsSchoolEntity {
  const NewsSchoolModel({required super.name});

  factory NewsSchoolModel.fromJson(Map<String, dynamic> json) {
    return NewsSchoolModel(
      name: json["name"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
