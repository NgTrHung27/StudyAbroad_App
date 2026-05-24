import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/change_pass.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/forget_password_page.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/logout_page.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/pages/ably_chat_page.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/pages/gemini_flash.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/contact_us_page.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/home_page.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/mainpage.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/splash.dart';
import 'package:study_abroad_cemc_mobile/features/intro/presentation/pages/intro.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/pages/news_page.dart';
import 'package:study_abroad_cemc_mobile/features/notifications/presentation/pages/notifications_page.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/help_feedback_page.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/profile_page.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/profile_detail.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/profile_status.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/requested.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/response_requested_page.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/scholar_detail.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/tuition.dart';
import 'package:study_abroad_cemc_mobile/features/scholarships/presentation/pages/scholarships_list.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/schools_list.dart';
import 'package:study_abroad_cemc_mobile/features/score/presentation/pages/scorepage.dart';

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
        return MaterialPageRoute(builder: (_) => const ForgetPassPage());
      case '/changepass':
        return MaterialPageRoute(builder: (_) => const ChangePass());
      case '/logout':
        return MaterialPageRoute(builder: (_) => const LogoutPage());
      case '/news':
        return MaterialPageRoute(builder: (_) => const NewsPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case '/profiledetail':
        return MaterialPageRoute(builder: (_) => const ProfileDetail());
      case '/profilestatus':
        return MaterialPageRoute(builder: (_) => const ProfileStatus());
      case '/help&feedback':
        return MaterialPageRoute(builder: (_) => const HelpFeedbackPage());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case '/contactus':
        return MaterialPageRoute(builder: (_) => const ContactUsPage());
      case '/schoolslistCanada':
        return MaterialPageRoute(
            builder: (_) => const SchoolsListPage(
                  country: 'CANADA',
                ));
      case '/scholarship':
        return MaterialPageRoute(builder: (_) => const ScholarshipsListPage());
      case '/gemini_ai':
        return MaterialPageRoute(builder: (_) => const GeminiAIFlash());
      case '/tuition':
        return MaterialPageRoute(builder: (_) => const TuitionStatusPage());
      case '/scholarDetail':
        return MaterialPageRoute(builder: (_) => const ScholarDetailPage());
      case '/respondrequest':
        return MaterialPageRoute(builder: (_) => const ResponseRequestPage());
      case '/respondrequested':
        return MaterialPageRoute(builder: (_) => const ResponseRequestedPage());
      case '/score':
        return MaterialPageRoute(builder: (_) => const ScorePage());
      case '/ablychat':
        return MaterialPageRoute(builder: (_) => const AblyChatPage());
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
