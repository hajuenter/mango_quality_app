import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/colors.dart';
import '../../controllers/mango_all_controller.dart';
import '../../widgets/date_picker_field.dart';
import '../../widgets/filter_chips_row.dart';
import '../../widgets/realtime_activity_card.dart';
import '../../widgets/skeletons/date_picker_field_skeleton.dart';
import '../../widgets/skeletons/filter_chips_row_skeleton.dart';
import '../../widgets/skeletons/realtime_activity_card_skeleton.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late final MangoAllController controller;

  String selectedFilter = 'Semua';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MangoAllController());
  }

  @override
  void dispose() {
    Get.delete<MangoAllController>(force: true);
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      selectedFilter = 'Semua';
      selectedDate = null;
    });
    await controller.refreshWithDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER ===
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
                'Detail Aktivitas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // === ISI ===
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: Obx(() {
                  final isLoading = controller.isLoading.value;
                  final dateFiltered = controller.filterByDate(selectedDate);
                  final filtered = controller.filterByType(
                    dateFiltered,
                    selectedFilter,
                  );

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // === Date Picker ===
                        Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: isLoading
                                ? const DatePickerFieldSkeleton()
                                : DatePickerField(
                                    selectedDate: selectedDate,
                                    onDateSelected: (date) {
                                      setState(() => selectedDate = date);
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // === Filter Chips ===
                        isLoading
                            ? const FilterChipsRowSkeleton()
                            : FilterChipsRow(
                                selectedFilter: selectedFilter,
                                onSelected: (filter) {
                                  setState(() => selectedFilter = filter);
                                },
                              ),

                        // === Daftar Aktivitas ===
                        Card(
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
                                if (isLoading)
                                  Column(
                                    children: List.generate(
                                      controller.allDetections.isNotEmpty
                                          ? controller.allDetections.length
                                          : 5,
                                      (_) =>
                                          const RealtimeActivityCardSkeleton(),
                                    ),
                                  )
                                else if (filtered.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inbox_outlined,
                                          size: 64,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          selectedDate != null
                                              ? 'Tidak ada aktivitas pada tanggal ini'
                                              : 'Belum ada aktivitas',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Column(
                                    children: filtered.map((detection) {
                                      return RealtimeActivityCard(
                                        type: detection.type,
                                        message: detection.message,
                                        time: detection.formattedTime,
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
