import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';

class SchoolModel extends SchoolEntity {
  const SchoolModel({
    required super.id,
    required super.logo,
    required super.background,
    required super.name,
    super.short,
    super.description,
    super.history,
    required super.color,
    required super.isPublished,
    required super.country,
    super.locations,
    super.programs,
    super.scholarships,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json["id"] ?? '',
      logo: json["logo"] ?? '',
      background: json["background"] ?? '',
      name: json["name"] ?? '',
      short: json["short"],
      description: json["description"],
      history: json["history"],
      color: json["color"] ?? '',
      isPublished: json["isPublished"] ?? false,
      country: json["country"] ?? '',
      locations: json["locations"] != null
          ? List<SchoolLocationModel>.from(
              json["locations"].map((x) => SchoolLocationModel.fromJson(x)))
          : null,
      programs: json["programs"] != null
          ? List<SchoolProgramModel>.from(
              json["programs"].map((x) => SchoolProgramModel.fromJson(x)))
          : null,
      scholarships: json["scholarships"] != null
          ? List<SchoolScholarshipModel>.from(
              json["scholarships"].map((x) => SchoolScholarshipModel.fromJson(x)))
          : null,
      createdAt: json["createdAt"] != null 
          ? DateTime.parse(json["createdAt"]) 
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null 
          ? DateTime.parse(json["updatedAt"]) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "background": background,
        "name": name,
        "short": short,
        "description": description,
        "history": history,
        "color": color,
        "isPublished": isPublished,
        "country": country,
        "locations": locations?.map((x) => (x as SchoolLocationModel).toJson()).toList(),
        "programs": programs?.map((x) => (x as SchoolProgramModel).toJson()).toList(),
        "scholarships": scholarships?.map((x) => (x as SchoolScholarshipModel).toJson()).toList(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class SchoolLocationModel extends SchoolLocationEntity {
  const SchoolLocationModel({
    required super.id,
    super.cover,
    super.name,
    super.description,
    super.address,
    super.isMain,
  });

  factory SchoolLocationModel.fromJson(Map<String, dynamic> json) {
    return SchoolLocationModel(
      id: json["id"] ?? '',
      cover: json["cover"],
      name: json["name"],
      description: json["description"],
      address: json["address"],
      isMain: json["isMain"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "cover": cover,
        "name": name,
        "description": description,
        "address": address,
        "isMain": isMain,
      };
}

class SchoolProgramModel extends SchoolProgramEntity {
  const SchoolProgramModel({
    required super.id,
    required super.name,
    required super.description,
    required super.cover,
    required super.isPublished,
  });

  factory SchoolProgramModel.fromJson(Map<String, dynamic> json) {
    return SchoolProgramModel(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      cover: json["cover"] ?? '',
      isPublished: json["isPublished"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "cover": cover,
        "isPublished": isPublished,
      };
}

class SchoolScholarshipModel extends SchoolScholarshipEntity {
  const SchoolScholarshipModel({
    required super.id,
    required super.name,
    required super.description,
    required super.cover,
    required super.isPublished,
  });

  factory SchoolScholarshipModel.fromJson(Map<String, dynamic> json) {
    return SchoolScholarshipModel(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      cover: json["cover"] ?? '',
      isPublished: json["isPublished"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "cover": cover,
        "isPublished": isPublished,
      };
}
