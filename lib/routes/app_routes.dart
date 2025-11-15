import 'package:get/get.dart';

import '../pages/apk/activity_page.dart';
import '../pages/apk/dashboard_page.dart';
import '../pages/apk/musim_intro_page.dart';
import '../pages/apk/musim_start_page.dart';
import '../pages/apk/report_and_history_page.dart';
import '../pages/apk/season_detail_page.dart';
import '../pages/apk/season_list_page.dart';
import '../pages/apk/setting_page.dart';
import '../pages/apk/statistic_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/nav/main_nav_page.dart';
import '../pages/splash_page.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgot = '/forgot';
  static const main = '/main';
  static const dashboard = '/dashboard';
  static const musimIntro = '/musim_intro';
  static const musimStart = '/musim_start';
  static const activity = '/activity';
  static const statistic = '/statistic';
  static const reportAndHistory = '/report_and_history';
  static const seasonList = '/season_list';
  static const seasonDetail = '/season_detail';
  static const setting = '/setting';

  static final routes = [
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: forgot, page: () => const ForgotPasswordPage()),
    GetPage(name: main, page: () => MainNavPage()),
    GetPage(name: dashboard, page: () => const DashboardPage()),
    GetPage(name: musimIntro, page: () => const MusimIntroPage()),
    GetPage(name: musimStart, page: () => const MusimStartPage()),
    GetPage(name: activity, page: () => const ActivityPage()),
    GetPage(name: statistic, page: () => const StatisticPage()),
    GetPage(name: reportAndHistory, page: () => const ReportAndHistoryPage()),
    GetPage(name: seasonList, page: () => SeasonListPage()),
    GetPage(name: seasonDetail, page: () => SeasonDetailPage()),
    GetPage(name: setting, page: () => const SettingPage()),
  ];
}
