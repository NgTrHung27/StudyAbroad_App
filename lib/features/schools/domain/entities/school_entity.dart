import 'package:equatable/equatable.dart';

class SchoolEntity extends Equatable {
  final String id;
  final String logo;
  final String background;
  final String name;
  final String? short;
  final String? description;
  final String? history;
  final String color;
  final bool isPublished;
  final String country;
  final List<SchoolLocationEntity>? locations;
  final List<SchoolProgramEntity>? programs;
  final List<SchoolScholarshipEntity>? scholarships;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SchoolEntity({
    required this.id,
    required this.logo,
    required this.background,
    required this.name,
    this.short,
    this.description,
    this.history,
    required this.color,
    required this.isPublished,
    required this.country,
    this.locations,
    this.programs,
    this.scholarships,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, country, isPublished];
}

class SchoolLocationEntity extends Equatable {
  final String id;
  final String? cover;
  final String? name;
  final String? description;
  final String? address;
  final bool? isMain;

  const SchoolLocationEntity({
    required this.id,
    this.cover,
    this.name,
    this.description,
    this.address,
    this.isMain,
  });

  @override
  List<Object?> get props => [id, name, address];
}

class SchoolProgramEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String cover;
  final bool isPublished;

  const SchoolProgramEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.cover,
    required this.isPublished,
  });

  @override
  List<Object?> get props => [id, name];
}

class SchoolScholarshipEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String cover;
  final bool isPublished;

  const SchoolScholarshipEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.cover,
    required this.isPublished,
  });

  @override
  List<Object?> get props => [id, name];
}
