import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/colors.dart';
import '../../controllers/healthy_rotten_count_controller.dart';
import '../../controllers/mango_latest_controller.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/realtime_activity_card.dart';
import '../../widgets/skeletons/dashboard_card_skeleton.dart';
import '../../widgets/skeletons/realtime_activity_card_skeleton.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final HealthyRottenCountController controller;
  late final MangoLatestController latestController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HealthyRottenCountController());
    latestController = Get.put(MangoLatestController());
  }

  @override
  void dispose() {
    Get.delete<HealthyRottenCountController>(force: true);
    Get.delete<MangoLatestController>(force: true);
    super.dispose();
  }

  Future<void> _refreshData() async {
    await Future.wait([
      controller.refreshWithDelay(),
      latestController.refreshWithDelay(),
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
                      // === Bagian Statistik ===
                      Obx(() {
                        final isLoading = controller.isLoading.value;
                        final healthyCount = controller.healthyCount.value;
                        final rottenCount = controller.rottenCount.value;

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
                                      imageAsset: 'assets/sehat.png',
                                      iconSize: 50,
                                      number: '$healthyCount',
                                      numberColor: AppColors.primaryAuth,
                                      numberFontSize: 40,
                                      label: 'Mangga Sehat',
                                    ),
                                    DashboardCard(
                                      imageAsset: 'assets/busuk.png',
                                      iconSize: 50,
                                      number: '$rottenCount',
                                      numberFontSize: 40,
                                      numberColor: AppColors.redAuth,
                                      label: 'Mangga Busuk',
                                    ),
                                    DashboardCard(
                                      imageAsset: 'assets/box.png',
                                      iconSize: 50,
                                      iconColor: Colors.black,
                                      number: '${healthyCount + rottenCount}',
                                      numberFontSize: 40,
                                      label: 'Total di Proses',
                                    ),
                                    DashboardCard(
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

                      // === Bagian Real-time Activity ===
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

                                  if (isLoading) {
                                    final placeholderCount =
                                        latestController
                                            .latestDetections
                                            .isNotEmpty
                                        ? latestController
                                              .latestDetections
                                              .length
                                        : 5;

                                    return Column(
                                      children: List.generate(
                                        placeholderCount,
                                        (_) =>
                                            const RealtimeActivityCardSkeleton(),
                                      ),
                                    );
                                  }

                                  if (detections.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        'Belum ada aktivitas',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }

                                  return Column(
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
