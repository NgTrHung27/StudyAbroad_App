import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/change_pass.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/forget_password.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/logout.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/pages/ably_websocket.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/pages/gemini_flash.dart';
import 'package:study_abroad_cemc_mobile/screens/home/contact_us.dart';
import 'package:study_abroad_cemc_mobile/screens/home/home_page.dart';
import 'package:study_abroad_cemc_mobile/screens/home/mainpage.dart';
import 'package:study_abroad_cemc_mobile/screens/home/splash.dart';
import 'package:study_abroad_cemc_mobile/screens/intro/intro.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/pages/news_page.dart';
import 'package:study_abroad_cemc_mobile/screens/notifications/notifications_page.dart';
import 'package:study_abroad_cemc_mobile/screens/profiles/help_feedback.dart';
import 'package:study_abroad_cemc_mobile/screens/profiles/profile.dart';
import 'package:study_abroad_cemc_mobile/screens/profiles/profile_detail.dart';
import 'package:study_abroad_cemc_mobile/screens/profiles/profile_status.dart';
import 'package:study_abroad_cemc_mobile/screens/profiles/requested.dart';
import 'package:study_abroad_cemc_mobile/screens/profiles/response_requested.dart';
import 'package:study_abroad_cemc_mobile/screens/profiles/scholar_detail.dart';
import 'package:study_abroad_cemc_mobile/screens/profiles/tuition.dart';
import 'package:study_abroad_cemc_mobile/screens/scholarships/scholarships_list.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/schools_list.dart';
import 'package:study_abroad_cemc_mobile/screens/score/scorepage.dart';

class AppRoute {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/forgotpass':
        return MaterialPageRoute(builder: (_) => const ForgetPass());
      case '/changepass':
        return MaterialPageRoute(builder: (_) => const ChangePass());
      case '/logout':
        return MaterialPageRoute(builder: (_) => const LogoutPage());
      case '/news':
        return MaterialPageRoute(builder: (_) => const NewsPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const Profile());
      case '/profiledetail':
        return MaterialPageRoute(builder: (_) => const ProfileDetail());
      case '/profilestatus':
        return MaterialPageRoute(builder: (_) => const ProfileStatus());
      case '/help&feedback':
        return MaterialPageRoute(builder: (_) => const HelpFeedback());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case '/contactus':
        return MaterialPageRoute(builder: (_) => const ContactUs());
      case '/schoolslistCanada':
        return MaterialPageRoute(
            builder: (_) => const SchoolsListPage(
                  country: 'CANADA',
                ));
      case '/scholarship':
        return MaterialPageRoute(builder: (_) => const ScholarshipsList());
      case '/gemini_ai':
        return MaterialPageRoute(builder: (_) => const GeminiAIFlash());
      case '/tuition':
        return MaterialPageRoute(builder: (_) => const TuitionStatus());
      case '/scholarDetail':
        return MaterialPageRoute(builder: (_) => const ScholarDetail());
      case '/respondrequest':
        return MaterialPageRoute(builder: (_) => const ResponseRequest());
      case '/respondrequested':
        return MaterialPageRoute(builder: (_) => const ResponseRequested());
      case '/score':
        return MaterialPageRoute(builder: (_) => const ScorePage());
      case '/ablychat':
        return MaterialPageRoute(builder: (_) => const AblyWebsocket());
      case '/intro':
        return MaterialPageRoute(builder: (_) => const IntroPage());
      case '/mainpage':
        final args = routeSettings.arguments as Map<String, dynamic>?;
        final index = args?['index'] ?? 0;
        return MaterialPageRoute(builder: (_) => MainPage(initialIndex: index));
      default:
        return MaterialPageRoute(builder: (_) => const MainPage());
    }
  }
}
