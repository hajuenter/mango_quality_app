import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango_app/widgets/skeletons/line_chart_statistic_skeleton.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/colors.dart';
import '../../controllers/mango_statistic_controller.dart';
import '../../widgets/bar_chart_statistic.dart';
import '../../widgets/line_chart_statistic.dart';
import '../../widgets/pie_chart_statistic.dart';
import '../../widgets/date_picker_field.dart';
import '../../widgets/skeletons/bar_chart_statistic_skeleton.dart';
import '../../widgets/skeletons/date_picker_field_skeleton.dart';
import '../../widgets/skeletons/pie_chart_statistic_skeleton.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MangoStatisticController controller = Get.put(
      MangoStatisticController(),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                'Data Statistik',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Body
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshWithDelay,
                child: Obx(() {
                  final loading = controller.isLoading.value;

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: DefaultTextStyle(
                      style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Date Picker
                          Card(
                            color: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: loading
                                  ? const DatePickerFieldSkeleton()
                                  : DatePickerField(
                                      selectedDate: controller.selectedDate,
                                      onDateSelected: (date) {
                                        controller.filterByDate(date);
                                      },
                                    ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Pie Chart (Per Hari)
                          loading
                              ? const PieChartStatisticSkeleton()
                              : PieChartStatistic(
                                  healthyCount: controller.healthyCount,
                                  rottenCount: controller.rottenCount,
                                ),
                          const SizedBox(height: 6),

                          // Bar Chart (Per Bulan)
                          loading
                              ? const BarChartStatisticSkeleton()
                              : BarChartStatistic(
                                  healthyPerMonth: controller.healthyPerMonth,
                                  rottenPerMonth: controller.rottenPerMonth,
                                ),
                          const SizedBox(height: 6),

                          // Line Chart (Per Tahun)
                          loading
                              ? const LineChartStatisticSkeleton()
                              : LineChartStatistic(
                                  healthyPerYear: controller.healthyPerYear,
                                  rottenPerYear: controller.rottenPerYear,
                                ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
