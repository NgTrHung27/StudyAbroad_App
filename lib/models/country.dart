// To parse this JSON data, do
//
//     final countryResponse = countryResponseFromJson(jsonString);

import 'dart:convert';

CountryResponse countryResponseFromJson(String str) =>
    CountryResponse.fromJson(json.decode(str));

String countryResponseToJson(CountryResponse data) =>
    json.encode(data.toJson());

class CountryResponse {
  int statusCode;
  String message;
  List<Country> data;

  CountryResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) => CountryResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: List<Country>.from(
            json["data"].map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Country {
  String name;
  String code;
  List<Province> provinces;

  Country({
    required this.name,
    required this.code,
    required this.provinces,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        name: json["name"],
        code: json["code"],
        provinces: List<Province>.from(
            json["provinces"].map((x) => Province.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "provinces": List<dynamic>.from(provinces.map((x) => x.toJson())),
      };
}

class Province {
  String name;
  List<String> districts;

  Province({
    required this.name,
    required this.districts,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        name: json["name"],
        districts: List<String>.from(json["districts"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "districts": List<dynamic>.from(districts.map((x) => x)),
      };
}

class District {
  String name;
  List<Ward> wards;

  District({
    required this.name,
    required this.wards,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        name: json["name"],
        wards: json["wards"] == null
            ? []
            : List<Ward>.from(json["wards"].map((x) => Ward.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "wards": List<dynamic>.from(wards.map((x) => x.toJson())),
      };
}

class Ward {
  String name;

  Ward({required this.name});

  factory Ward.fromJson(Map<String, dynamic> json) => Ward(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
