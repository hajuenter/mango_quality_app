import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/colors.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    await _loadData();
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
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          int crossAxisCount = width > 600 ? 4 : 2;
                          double childAspectRatio =
                              (width / crossAxisCount) / 180;

                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _isLoading ? 4 : 4,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: childAspectRatio,
                                  ),
                              itemBuilder: (context, index) {
                                if (_isLoading) {
                                  return const DashboardCardSkeleton(
                                    numberAreaHeight:
                                        40, // sama dengan DashboardCard
                                    iconSize: 50,
                                  );
                                } else {
                                  final cards = [
                                    DashboardCard(
                                      imageAsset: 'assets/sehat.png',
                                      iconSize: 50,
                                      number: '120',
                                      numberColor: AppColors.primaryAuth,
                                      numberFontSize: 40,
                                      label: 'Mangga Sehat',
                                    ),
                                    DashboardCard(
                                      imageAsset: 'assets/busuk.png',
                                      iconSize: 50,
                                      number: '5',
                                      numberFontSize: 40,
                                      numberColor: AppColors.redAuth,
                                      label: 'Mangga Busuk',
                                    ),
                                    DashboardCard(
                                      imageAsset: 'assets/box.png',
                                      iconSize: 50,
                                      iconColor: Colors.black,
                                      number: '80',
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
                                }
                              },
                            ),
                          );
                        },
                      ),

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
                                  child: _isLoading
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey.shade100,
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
                                        ),
                                ),
                                const SizedBox(height: 6),

                                Column(
                                  children: _isLoading
                                      ? List.generate(
                                          5,
                                          (_) =>
                                              const RealtimeActivityCardSkeleton(),
                                        )
                                      : const [
                                          RealtimeActivityCard(
                                            type: 'sehat',
                                            message: 'Mangga Sehat Terdeteksi',
                                            time: '21/10/2025 12:23:32',
                                          ),
                                          RealtimeActivityCard(
                                            type: 'sehat',
                                            message: 'Mangga Sehat Terdeteksi',
                                            time: '21/10/2025 12:23:28',
                                          ),
                                          RealtimeActivityCard(
                                            type: 'busuk',
                                            message: 'Mangga Busuk Terdeteksi',
                                            time: '21/10/2025 12:23:19',
                                          ),
                                          RealtimeActivityCard(
                                            type: 'sehat',
                                            message: 'Mangga Sehat Terdeteksi',
                                            time: '21/10/2025 12:23:14',
                                          ),
                                          RealtimeActivityCard(
                                            type: 'busuk',
                                            message: 'Mangga Busuk Terdeteksi',
                                            time: '21/10/2025 12:23:19',
                                          ),
                                        ],
                                ),
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
