import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/features/schools/data/models/school_model.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/failures/school_failures.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/repositories/school_repository.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final http.Client _client;

  SchoolRepositoryImpl({http.Client? client})
      : _client = client ?? http.Client();

  @override
  Future<Either<SchoolFailure, List<SchoolEntity>>> getSchools() async {
    try {
      final response = await _client.get(Uri.parse(ApiUrls.schoolsFull));

      if (response.statusCode == 200) {
        List<dynamic> data =
            jsonDecode(utf8.decode(latin1.encode(response.body)));
        List<SchoolModel> schools =
            data.map((json) => SchoolModel.fromJson(json)).toList();
        return Right(schools);
      } else {
        return const Left(SchoolServerFailure('Failed to load schools'));
      }
    } catch (e) {
      return const Left(SchoolNetworkFailure());
    }
  }

  @override
  Future<Either<SchoolFailure, List<String>>> getUniqueCountries() async {
    try {
      final response = await _client.get(Uri.parse(ApiUrls.schools));

      if (response.statusCode == 200) {
        List<dynamic> data =
            jsonDecode(utf8.decode(latin1.encode(response.body)));
        List<SchoolModel> schools =
            data.map((json) => SchoolModel.fromJson(json)).toList();
        List<String> countries =
            schools.map((school) => school.country).toSet().toList();
        return Right(countries);
      } else {
        return const Left(
            SchoolServerFailure('Failed to load unique countries'));
      }
    } catch (e) {
      return const Left(SchoolNetworkFailure());
    }
  }
}
