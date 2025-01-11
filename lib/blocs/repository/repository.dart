import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:kltn_mobile/models/country.dart';
import 'package:kltn_mobile/models/news.dart';
import 'package:kltn_mobile/models/news_school.dart';
import 'package:kltn_mobile/models/schools.dart';
import 'package:kltn_mobile/models/user_changepass.dart';
import 'package:kltn_mobile/models/user_forgot.dart';
import 'package:kltn_mobile/models/user_login.dart';
import 'package:kltn_mobile/models/user_register.dart';
import 'package:kltn_mobile/screens/home/contact_us.dart';
import 'package:kltn_mobile/models/user_login.dart' as user_login;

class APIRepository {
  http.Client get httpClient => http.Client();
  Future<UserAuthRegister?> register(
    String email,
    String name,
    String password,
    String confirmpassword,
    String idCardNumber,
    DateTime dob,
    String phone,
    String? selectedSchool,
    String? selectedCountry,
    String? selectedProgram,
    String? selectedCity,
    String? selectedDistrict,
    String? selectedWard,
    String address,
    String? valueGender,
    String? valueDegree,
    String? radioGradeTypeValue,
    String? gradeScore,
    String? selectedCertificateType,
    String? certificateImg,
  ) async {
    try {
      String jsonData = jsonEncode({
        "email": email,
        "name": name,
        "password": password,
        "confirmPassword": confirmpassword,
        "idCardNumber": idCardNumber,
        "dob": dob.toIso8601String(),
        "phoneNumber": phone,
        "schoolName": selectedSchool,
        "country": selectedCountry,
        "programName": selectedProgram,
        "city": selectedCity,
        "district": selectedDistrict,
        "ward": selectedWard,
        "addressLine": address,
        "gender": valueGender,
        "degreeType": valueDegree,
        "gradeType": radioGradeTypeValue,
        "gradeScore": gradeScore,
        "certificateType": selectedCertificateType,
        "certificateImg": certificateImg,
      });
      final response = await http.post(
        Uri.parse(
            'https://kltn-demo-deploy-admin.vercel.app/api/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        log('data: $data');

        return UserAuthRegister.fromJson(data);
      } else if (response.statusCode == 406) {
        final responseData = jsonDecode(response.body);
        final errors = responseData['error'] as List<dynamic>;
        for (final error in errors) {
          final code = error['code'];
          final message = error['message'];
          final path = error['path'];
          print('Error: Code $code, Message: $message, Path: $path');
        }

        // Return an instance of UserAuthRegister with the error details
        return UserAuthRegister(error: 'Failed to register with status 406');
      } else {
        return UserAuthRegister(error: 'Failed to register');
      }
    } catch (e) {
      return UserAuthRegister(error: 'Exception: $e');
    }
  }

  Future<UserAuthLogin?> login(
    String email,
    String password,
  ) async {
    try {
      final response = await httpClient.post(
        Uri.parse('https://kltn-demo-deploy-admin.vercel.app/api/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: utf8.encode(jsonEncode({"email": email, "password": password})),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        log('data: $data');
        return UserAuthLogin.fromJson(data);
      } else if (response.statusCode == 401) {
        // Tạo một đối tượng UserAuthLogin với thông báo lỗi
        return UserAuthLogin(
          id: '',
          email: email,
          password: password,
          emailVerified: DateTime.now(),
          name: '',
          dob: DateTime.now(),
          phoneNumber: '',
          student: user_login.Student
              .empty(), // Giả định là bạn có class Student mặc định
          isLocked: false,
          token: '',
          error: data['error'], // Lưu lỗi vào trường error
        );
      } else {
        // Tương tự, trả về đối tượng UserAuthLogin với lỗi
        return UserAuthLogin(
          id: '',
          email: email,
          password: password,
          emailVerified: DateTime.now(),
          name: '',
          dob: DateTime.now(),
          phoneNumber: '',
          student: user_login.Student.empty(),
          isLocked: false,
          token: '',
          error: data['error'],
        );
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Country>> fetchCountry() async {
    try {
      final response = await http.get(
        Uri.parse('https://kltn-demo-deploy-admin.vercel.app/api/country'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data =
            jsonDecode(utf8.decode(latin1.encode(response.body)));
        List<Country> countries = [];
        for (var item in data) {
          Country country = Country.fromJson(item);
          countries.add(country);
        }
        return countries;
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API Country');
    }
  }

  Future<List<Schools>> fetchSchools() async {
    try {
      final response = await httpClient.get(
        Uri.parse('https://kltn-demo-deploy-admin.vercel.app/api/schools/full'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data =
            jsonDecode(utf8.decode(latin1.encode(response.body)));
        List<Schools> schools = [];
        for (var item in data) {
          // Tạo một đối tượng School từ JSON
          Schools school = Schools.fromJson(item);
          // Thêm đối tượng School vào danh sách schools
          schools.add(school);
        }
        return schools;
      } else {
        throw Exception('Failed to load schools');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API School: $e');
    }
  }

  Future<List<String>> fetchUniqueCountries() async {
    final response = await httpClient.get(
        Uri.parse('https://kltn-demo-deploy-admin.vercel.app/api/schools'));
    final schools = schoolsFromJson(response.body);
    final countries = schools.map((school) => school.country).toSet().toList();
    return countries;
  }

  Future<UserForgotpass?> forgotPass(String email) async {
    try {
      final response = await httpClient.post(
        Uri.parse(
            'https://kltn-demo-deploy-admin.vercel.app/api/auth/reset-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        log('data: $data');
        return UserForgotpass.fromJson(data);
      } else {
        return UserForgotpass.fromJson(data);
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserChangePass?> changePass(String email) async {
    try {
      final response = await httpClient.post(
        Uri.parse(
            'https://kltn-demo-deploy-admin.vercel.app/api/auth/reset-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        log('data: $data');
        return UserChangePass.fromJson(data);
      } else {
        return UserChangePass.fromJson(data);
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<NewsList>> fetchNews() async {
    try {
      final response = await httpClient.get(
        Uri.parse('https://kltn-demo-deploy-admin.vercel.app/api/news'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data =
            jsonDecode(utf8.decode(latin1.encode(response.body)));
        List<NewsList> news = [];
        for (var item in data) {
          try {
            NewsList newss = NewsList.fromJson(item);
            news.add(newss);
          } catch (e) {
            print('Error processing item: $e');
          }
        }
        return news;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API News');
    }
  }

  Future<List<NewsSchoolList>> fetchSchoolNews() async {
    try {
      final response = await httpClient.get(
        Uri.parse('https://kltn-demo-deploy-admin.vercel.app/api/news'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data =
            jsonDecode(utf8.decode(latin1.encode(response.body)));
        List<NewsSchoolList> news = [];
        for (var item in data) {
          try {
            NewsSchoolList newss = NewsSchoolList.fromJson(item);
            news.add(newss);
          } catch (e) {
            print('Error processing item: $e');
          }
        }
        return news;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API News');
    }
  }

  Future<ContactUs?> contactUs(
    String name,
    String email,
    String title,
    String phone,
    String message,
    String? schoolId,
  ) async {
    try {
      String jsonDataContact = jsonEncode({
        "name": name,
        "email": email,
        "title": title,
        "phone": phone,
        "message": message,
        "schoolId": schoolId,
      });
      final responseContactUs = await httpClient.post(
        Uri.parse('https://kltn-demo-deploy-admin.vercel.app/api/feedbacks'),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonDataContact,
      );

      if (responseContactUs.statusCode == 200) {
        final dataContactUs =
            jsonDecode(utf8.decode(responseContactUs.bodyBytes));
        log('data: $dataContactUs');
      } else if (responseContactUs.statusCode == 400) {
        final responseData = jsonDecode(responseContactUs.body);
        final errors = responseData['error'] as List<dynamic>;
        for (final error in errors) {
          final code = error['code'];
          final message = error['message'];
          final path = error['path'];
          print('Error: Code $code, Message: $message, Path: $path');
        }
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
