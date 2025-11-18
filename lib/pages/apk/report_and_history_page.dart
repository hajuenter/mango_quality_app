import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/colors.dart';
import '../../controllers/mango_daily_controller.dart';
import '../../controllers/season_controller.dart';
import '../../widgets/custom_date_range_picker.dart';
import '../../widgets/custom_table.dart';
import '../../widgets/custom_table_empty.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/download_pdf_button.dart';
import '../../widgets/filter_chips_row.dart';
import '../../widgets/season_download_bottom_sheet.dart';
import '../../widgets/skeletons/custom_table_skeleton.dart';
import '../../widgets/skeletons/dashboard_card_skeleton.dart';
import '../../widgets/skeletons/download_pdf_button_skeleton.dart';
import '../../widgets/skeletons/filter_chips_row_skeleton.dart';

class ReportAndHistoryPage extends StatefulWidget {
  const ReportAndHistoryPage({super.key});

  @override
  State<ReportAndHistoryPage> createState() => _ReportAndHistoryPageState();
}

class _ReportAndHistoryPageState extends State<ReportAndHistoryPage> {
  late final MangoDailyController controller;
  late final SeasonController seasonController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MangoDailyController(), tag: "daily_report");
    seasonController = Get.put(SeasonController(), tag: "history_seasons");
  }

  @override
  void dispose() {
    Get.delete<MangoDailyController>(tag: "daily_report", force: true);
    Get.delete<SeasonController>(tag: "history_seasons", force: true);
    super.dispose();
  }

  Future<void> _refreshData() async {
    await Future.wait([
      controller.refreshWithDelay(),
      seasonController.refreshWithDelay(),
    ]);
  }

  void _navigateToSeasonList() {
    FocusScope.of(context).unfocus();
    Get.toNamed('/season_list');
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
              child: Text(
                'Laporan dan Riwayat',
                style: GoogleFonts.rubik(
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                if (controller.isLoading.value) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          height: 20,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          height: 14,
                                          width: 220,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Laporan Sortir',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Saat ini anda berada di filter ${controller.selectedFilter.value.toLowerCase()}',
                                      style: GoogleFonts.rubik(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 12),

                              Obx(() {
                                return controller.isLoading.value
                                    ? const FilterChipsRowSkeleton()
                                    : FilterChipsRow(
                                        selectedFilter:
                                            controller.selectedFilter.value,
                                        filters: const [
                                          'Harian',
                                          'Musim Panen',
                                          'Custom',
                                        ],
                                        onSelected: (filter) {
                                          if (filter == 'Custom') {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              barrierColor: Colors.black54,
                                              builder: (context) {
                                                return CustomDateRangePicker(
                                                  onApply: (start, end) {
                                                    controller
                                                        .setCustomDateRange(
                                                          start,
                                                          end,
                                                        );
                                                  },
                                                );
                                              },
                                            );
                                          } else if (filter == 'Harian') {
                                            controller.changeDate(
                                              DateTime.now(),
                                            );
                                          } else if (filter == 'Musim Panen') {
                                            _navigateToSeasonList();
                                          }
                                        },
                                      );
                              }),

                              const SizedBox(height: 16),

                              Obx(() {
                                if (controller.isLoading.value) {
                                  return Row(
                                    children: const [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: DashboardCardSkeleton(
                                            numberAreaHeight: 50,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: DashboardCardSkeleton(
                                            numberAreaHeight: 50,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: DashboardCardSkeleton(
                                            numberAreaHeight: 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: DashboardCard(
                                          imageAsset: 'assets/sehat.png',
                                          number: '${controller.healthyCount}',
                                          label: 'Sehat',
                                          numberColor: AppColors.primaryAuth,
                                          numberFontSize: 36,
                                          numberAreaHeight: 50,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: DashboardCard(
                                          imageAsset: 'assets/busuk.png',
                                          number: '${controller.rottenCount}',
                                          label: 'Busuk',
                                          numberColor: AppColors.redAuth,
                                          numberFontSize: 36,
                                          numberAreaHeight: 50,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: DashboardCard(
                                          imageAsset: 'assets/box.png',
                                          number: '${controller.totalCount}',
                                          label: 'Total',
                                          numberFontSize: 36,
                                          numberAreaHeight: 50,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),

                              const SizedBox(height: 16),

                              Center(
                                child: Obx(() {
                                  return controller.isLoading.value
                                      ? const DownloadPdfButtonSkeleton()
                                      : DownloadPdfButton(
                                          onPressed: () {
                                            final seasons = seasonController
                                                .seasonList
                                                .where(
                                                  (s) => s.status != 'active',
                                                )
                                                .toList();

                                            SeasonDownloadBottomSheet.show(
                                              context,
                                              seasons,
                                            );
                                          },
                                        );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                if (seasonController.isLoading.value) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          height: 20,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Riwayat Musim',
                                      style: GoogleFonts.rubik(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                );
                              }),

                              Obx(() {
                                if (seasonController.isLoading.value) {
                                  return const CustomTableSkeleton();
                                }

                                final inactiveSeasons = seasonController
                                    .seasonList
                                    .where((s) => s.status != 'active')
                                    .toList();

                                if (inactiveSeasons.isEmpty) {
                                  return const EmptyTableState();
                                }

                                return Scrollbar(
                                  thumbVisibility: true,
                                  thickness: 4,
                                  radius: const Radius.circular(8),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Table(
                                      columnWidths: const {
                                        0: FixedColumnWidth(190),
                                        1: FixedColumnWidth(80),
                                        2: FixedColumnWidth(80),
                                        3: FixedColumnWidth(80),
                                      },
                                      border: TableBorder.symmetric(
                                        inside: BorderSide(
                                          color: Colors.grey,
                                          width: 0.2,
                                        ),
                                      ),
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                          ),
                                          children: const [
                                            CustomTableHeader(
                                              text: 'Musim Panen',
                                            ),
                                            CustomTableHeader(text: 'Sehat'),
                                            CustomTableHeader(text: 'Busuk'),
                                            CustomTableHeader(text: 'Total'),
                                          ],
                                        ),
                                        for (var season in inactiveSeasons)
                                          TableRow(
                                            children: [
                                              CustomTableCell(
                                                text: season.name,
                                              ),
                                              CustomTableCell(
                                                text: season.healthyCount
                                                    .toString(),
                                              ),
                                              CustomTableCell(
                                                text: season.rottenCount
                                                    .toString(),
                                              ),
                                              CustomTableCell(
                                                text: season.totalCount
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
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
