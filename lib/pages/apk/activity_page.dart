import 'package:flutter/material.dart';

import '../../config/colors.dart';
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
  String selectedFilter = 'Semua';
  DateTime? selectedDate;

  bool _isLoading = true; // Tambahkan loading state

  final List<Map<String, dynamic>> activities = [
    {
      'type': 'sehat',
      'message': 'Mangga Sehat Terdeteksi',
      'time': '01/11/2025 08:23:12',
    },
    {
      'type': 'busuk',
      'message': 'Mangga Busuk Terdeteksi',
      'time': '01/11/2025 08:25:45',
    },
    {
      'type': 'sehat',
      'message': 'Mangga Sehat Terdeteksi',
      'time': '01/11/2025 08:27:03',
    },
    {
      'type': 'sehat',
      'message': 'Mangga Sehat Terdeteksi',
      'time': '01/11/2025 08:30:22',
    },
    {
      'type': 'busuk',
      'message': 'Mangga Busuk Terdeteksi',
      'time': '01/11/2025 08:32:10',
    },
    {
      'type': 'sehat',
      'message': 'Mangga Sehat Terdeteksi',
      'time': '01/11/2025 08:35:05',
    },
    {
      'type': 'busuk',
      'message': 'Mangga Busuk Terdeteksi',
      'time': '01/11/2025 08:37:18',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulasi fetch data
    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = selectedFilter == 'Semua'
        ? activities
        : activities
              .where((a) => a['type'] == selectedFilter.toLowerCase())
              .toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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

            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // DATE PICKER
                      Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: _isLoading
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

                      _isLoading
                          ? const FilterChipsRowSkeleton()
                          : FilterChipsRow(
                              selectedFilter: selectedFilter,
                              onSelected: (filter) {
                                setState(() => selectedFilter = filter);
                              },
                            ),

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
                              Column(
                                children: _isLoading
                                    ? List.generate(
                                        selectedFilter == 'Semua'
                                            ? (activities.isNotEmpty
                                                  ? activities.length
                                                  : 5)
                                            : (activities
                                                      .where(
                                                        (a) =>
                                                            a['type'] ==
                                                            selectedFilter
                                                                .toLowerCase(),
                                                      )
                                                      .isNotEmpty
                                                  ? activities
                                                        .where(
                                                          (a) =>
                                                              a['type'] ==
                                                              selectedFilter
                                                                  .toLowerCase(),
                                                        )
                                                        .length
                                                  : 5),
                                        (_) =>
                                            const RealtimeActivityCardSkeleton(),
                                      )
                                    : filtered
                                          .map(
                                            (activity) => RealtimeActivityCard(
                                              type: activity['type'],
                                              message: activity['message'],
                                              time: activity['time'],
                                            ),
                                          )
                                          .toList(),
                              ),
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
