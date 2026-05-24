import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/forget_password_page.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/home_page.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/mainpage.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/schools_list.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/schools_detail.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/pages/news_page.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/pages/news_detail.dart';
import 'package:study_abroad_cemc_mobile/features/notifications/presentation/pages/notifications_page.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/profile_page.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/profile_detail.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/profile_status.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/tuition.dart';
import 'package:study_abroad_cemc_mobile/features/score/presentation/pages/scorepage.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/change_pass.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/logout_page.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/contact_us_page.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/search_page.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/pages/scholarships_list.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/pages/scholarships_detail.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/compare_schools.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/respond.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/response_requested_detail.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/response_requested_page.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/requested.dart';

class AppRoute {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String mainpage = '/mainpage';
  static const String schools = '/schools';
  static const String schoolDetail = '/schools/detail';
  static const String news = '/news';
  static const String newsDetail = '/news/detail';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String profiledetail = '/profiledetail';
  static const String changepass = '/changepass';
  static const String logout = '/logout';
  static const String helpfeedback = '/help&feedback';
  static const String profilestatus = '/profilestatus';
  static const String scholarDetail = '/scholarDetail';
  static const String tuition = '/tuition';
  static const String score = '/score';
  static const String contact = '/contact';
  static const String search = '/search';
  static const String scholarships = '/scholarships';
  static const String scholarshipDetail = '/scholarshipDetail';
  static const String compareSchool = '/compareSchool';
  static const String respondrequest = '/respondrequest';
  static const String respondrequested = '/respondrequested';
  static const String respondrequesteddetail = '/respondrequesteddetail';
  static const String requested = '/requested';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPassPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case mainpage:
        final args = settings.arguments;
        int initialIndex = 0;
        if (args != null && args is Map && args.containsKey('index')) {
          initialIndex = args['index'] as int;
        }
        return MaterialPageRoute(
            builder: (_) => MainPage(initialIndex: initialIndex));
      case schools:
        final args = settings.arguments;
        String country = 'ALL';
        if (args != null && args is Map && args.containsKey('country')) {
          country = args['country'] as String;
        }
        return MaterialPageRoute(
            builder: (_) => SchoolsListPage(country: country));
      case schoolDetail:
        final school = settings.arguments;
        if (school is SchoolEntity) {
          return MaterialPageRoute(
              builder: (_) => SchoolsDetail(school: school));
        }
        return MaterialPageRoute(
            builder: (_) => const SchoolsListPage(country: 'ALL'));
      case news:
        return MaterialPageRoute(builder: (_) => const NewsPage());
      case newsDetail:
        final newsData = settings.arguments;
        if (newsData is NewsEntity) {
          return MaterialPageRoute(
              builder: (_) => NewsDetailPage(news: newsData));
        }
        return MaterialPageRoute(builder: (_) => const NewsPage());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case profiledetail:
        return MaterialPageRoute(builder: (_) => const ProfileDetail());
      case changepass:
        return MaterialPageRoute(builder: (_) => const ChangePass());
      case logout:
        return MaterialPageRoute(builder: (_) => const LogoutPage());
      case helpfeedback:
        return MaterialPageRoute(builder: (_) => const ContactUsPage());
      case profilestatus:
        return MaterialPageRoute(builder: (_) => const ProfileStatus());
      case scholarDetail:
        return MaterialPageRoute(
            builder: (_) =>
                const ScholarshipsDetail(name: '', description: '', id: ''));
      case tuition:
        return MaterialPageRoute(builder: (_) => const TuitionStatusPage());
      case score:
        return MaterialPageRoute(builder: (_) => const ScorePage());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case scholarships:
        return MaterialPageRoute(builder: (_) => const ScholarshipsListPage());
      case scholarshipDetail:
        final args = settings.arguments;
        if (args != null && args is Map) {
          return MaterialPageRoute(
              builder: (_) => ScholarshipsDetail(
                    name: args['name'] ?? '',
                    description: args['description'] ?? '',
                    id: args['id'] ?? '',
                  ));
        }
        return MaterialPageRoute(builder: (_) => const ScholarshipsListPage());
      case compareSchool:
        final args = settings.arguments;
        if (args != null && args is Map && args.containsKey('schoolNames')) {
          return MaterialPageRoute(
              builder: (_) =>
                  CompareSchoolsPage(schoolNames: args['schoolNames']));
        }
        return MaterialPageRoute(
            builder: (_) => const CompareSchoolsPage(schoolNames: []));
      case respondrequest:
        final args = settings.arguments;
        if (args != null && args is Map) {
          return MaterialPageRoute(
              builder: (_) => Respond(
                    title: args['title'] ?? '',
                    description: args['description'] ?? '',
                    id: args['id'] ?? '',
                    images: args['images'],
                  ));
        }
        return MaterialPageRoute(
            builder: (_) => Respond(
                  title: '',
                  description: '',
                  id: '',
                  images: null,
                ));
      case respondrequested:
        return MaterialPageRoute(builder: (_) => const ResponseRequestedPage());
      case respondrequesteddetail:
        final args = settings.arguments;
        if (args != null && args is Map) {
          return MaterialPageRoute(
              builder: (_) => ResponseRequestedDetail(
                    title: args['title'] ?? '',
                    replies: args['replies'] ?? [],
                  ));
        }
        return MaterialPageRoute(
            builder: (_) =>
                const ResponseRequestedDetail(title: '', replies: []));
      case requested:
        return MaterialPageRoute(builder: (_) => const ResponseRequestPage());
      default:
        return MaterialPageRoute(builder: (_) => const MainPage());
    }
  }
}
