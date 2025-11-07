import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/colors.dart';
import '../../controllers/healthy_rotten_count_controller.dart';
import '../../controllers/mango_latest_controller.dart';
import '../../widgets/dashboard_card.dart';
import '../../controllers/nav_controller.dart';
import '../../widgets/realtime_activity_card.dart';
import '../../widgets/skeletons/dashboard_card_skeleton.dart';
import '../../widgets/skeletons/realtime_activity_card_skeleton.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  late final HealthyRottenCountController controller;
  late final MangoLatestController latestController;
  late final NavController navController;
  Worker? _navWorker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.put(HealthyRottenCountController());
    latestController = Get.put(MangoLatestController());
    navController = Get.find<NavController>();

    _navWorker = ever(navController.currentIndex, (index) {
      if (index == 0) {
        controller.resumePolling();
        latestController.resumePolling();
      } else {
        controller.pausePolling();
        latestController.pausePolling();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _navWorker?.dispose();
    controller.pausePolling();
    latestController.pausePolling();
    Get.delete<HealthyRottenCountController>(force: true);
    Get.delete<MangoLatestController>(force: true);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed &&
        navController.currentIndex.value == 0) {
      controller.resumePolling();
      latestController.resumePolling();
    } else if (state == AppLifecycleState.paused) {
      controller.pausePolling();
      latestController.pausePolling();
    }
  }

  Future<void> _refreshData() async {
    await Future.wait([
      controller.fetchDetectionsWithDelay(),
      latestController.fetchLatestDetectionsWithDelay(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.primaryAuth,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: const Text(
                'Monitor Sortir Mangga',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        final isLoading = controller.isLoading.value;
                        final healthyCount = controller.healthyList.length;
                        final rottenCount = controller.rottenList.length;

                        final key = ValueKey('$healthyCount-$rottenCount');

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            double width = constraints.maxWidth;
                            int crossAxisCount = width > 600 ? 4 : 2;
                            double childAspectRatio =
                                (width / crossAxisCount) / 180;

                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: GridView.builder(
                                key: key,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: childAspectRatio,
                                    ),
                                itemBuilder: (context, index) {
                                  if (isLoading) {
                                    return const DashboardCardSkeleton(
                                      numberAreaHeight: 40,
                                      iconSize: 50,
                                    );
                                  }

                                  final cards = [
                                    DashboardCard(
                                      key: ValueKey('healthy-$healthyCount'),
                                      imageAsset: 'assets/sehat.png',
                                      iconSize: 50,
                                      number: '$healthyCount',
                                      numberColor: AppColors.primaryAuth,
                                      numberFontSize: 40,
                                      label: 'Mangga Sehat',
                                    ),
                                    DashboardCard(
                                      key: ValueKey('rotten-$rottenCount'),
                                      imageAsset: 'assets/busuk.png',
                                      iconSize: 50,
                                      number: '$rottenCount',
                                      numberFontSize: 40,
                                      numberColor: AppColors.redAuth,
                                      label: 'Mangga Busuk',
                                    ),
                                    DashboardCard(
                                      key: ValueKey(
                                        'total-${healthyCount + rottenCount}',
                                      ),
                                      imageAsset: 'assets/box.png',
                                      iconSize: 50,
                                      iconColor: Colors.black,
                                      number: '${healthyCount + rottenCount}',
                                      numberFontSize: 40,
                                      label: 'Total di Proses',
                                    ),
                                    DashboardCard(
                                      key: const ValueKey('status-conveyor'),
                                      imageAsset: 'assets/conveyor.png',
                                      iconSize: 50,
                                      iconColor: Colors.green,
                                      statusDotColor: Colors.green,
                                      number: 'Berjalan',
                                      numberFontSize: 20,
                                      label: 'Status Conveyor',
                                    ),
                                  ];
                                  return cards[index];
                                },
                              ),
                            );
                          },
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Obx(() {
                                    final isLoading =
                                        controller.isLoading.value;
                                    return isLoading
                                        ? Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                              width: 150,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                          )
                                        : const Text(
                                            'Aktivitas Real-Time',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          );
                                  }),
                                ),
                                const SizedBox(height: 6),
                                Obx(() {
                                  final isLoading =
                                      latestController.isLoading.value;
                                  final detections =
                                      latestController.latestDetections;

                                  return isLoading
                                      ? Column(
                                          children: List.generate(
                                            latestController
                                                    .latestDetections
                                                    .isNotEmpty
                                                ? latestController
                                                      .latestDetections
                                                      .length
                                                : 5,
                                            (_) =>
                                                const RealtimeActivityCardSkeleton(),
                                          ),
                                        )
                                      : detections.isEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            'Belum ada aktivitas',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Column(
                                          children: detections.map((detection) {
                                            return RealtimeActivityCard(
                                              type: detection.type,
                                              message: detection.message,
                                              time: detection.formattedTime,
                                            );
                                          }).toList(),
                                        );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
