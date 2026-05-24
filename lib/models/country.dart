// To parse this JSON data, do
//
//     final country = countryFromJson(jsonString);

import 'dart:convert';

List<Country> countryFromJson(String str) =>
    List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));

String countryToJson(List<Country> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  String id;
  String name;
  List<District> districts;

  Country({
    required this.id,
    required this.name,
    required this.districts,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["Id"],
        name: json["Name"],
        districts: List<District>.from(
            json["Districts"].map((x) => District.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Districts": List<dynamic>.from(districts.map((x) => x.toJson())),
      };
}

class District {
  String id;
  String name;
  List<Ward> wards;

  District({
    required this.id,
    required this.name,
    required this.wards,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["Id"],
        name: json["Name"],
        wards: List<Ward>.from(json["Wards"].map((x) => Ward.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Wards": List<dynamic>.from(wards.map((x) => x.toJson())),
      };
}

class Ward {
  String id;
  String name;
  Level level;

  Ward({
    required this.id,
    required this.name,
    required this.level,
  });

  factory Ward.fromJson(Map<String, dynamic> json) => Ward(
        id: json["Id"],
        name: json["Name"],
        level: levelValues.map[json["Level"]]!,
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Level": levelValues.reverse[level],
      };
}

enum Level { phuong, thitran, xa }

final levelValues = EnumValues(
    {"Phường": Level.phuong, "Thị trấn": Level.thitran, "Xã": Level.xa});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
