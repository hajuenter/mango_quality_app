import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/nav_controller.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../apk/activity_page.dart';
import '../apk/dashboard_page.dart';
import '../apk/report_and_history_page.dart';
import '../apk/setting_page.dart';
import '../apk/statistic_page.dart';

class MainNavPage extends StatelessWidget {
  MainNavPage({super.key});

  final NavController navController = Get.find<NavController>();

  final List<Widget> pages = const [
    DashboardPage(),
    ActivityPage(),
    StatisticPage(),
    ReportAndHistoryPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: IndexedStack(
            index: navController.currentIndex.value,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
