import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/colors.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/filter_chips_row.dart';
import '../../widgets/custom_table_widgets.dart';

class ReportAndHistoryPage extends StatefulWidget {
  const ReportAndHistoryPage({super.key});

  @override
  State<ReportAndHistoryPage> createState() => _ReportAndHistoryPageState();
}

class _ReportAndHistoryPageState extends State<ReportAndHistoryPage> {
  String selectedFilter = 'Harian';

  final List<Map<String, dynamic>> seasonHistory = [
    {
      "period": "12/08/2025-09/09/2025",
      "healthy": 990,
      "rotten": 98,
      "total": 1088,
    },
    {
      "period": "08/03/2025-10/05/2025",
      "healthy": 996,
      "rotten": 12,
      "total": 1008,
    },
    {
      "period": "07/11/2024-29/12/2024",
      "healthy": 1136,
      "rotten": 102,
      "total": 1238,
    },
    {
      "period": "02/04/2024-11/05/2024",
      "healthy": 1024,
      "rotten": 30,
      "total": 1054,
    },
  ];

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

            // === BODY ===
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {},
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // === Laporan Sortir ===
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
                              Text(
                                'Laporan Sortir',
                                style: GoogleFonts.rubik(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Saat ini anda berada di filter periode panen '
                                '${selectedFilter.toLowerCase()} (21/10/2025)',
                                style: GoogleFonts.rubik(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // === Filter Chips ===
                              FilterChipsRow(
                                selectedFilter: selectedFilter,
                                filters: ['Harian', 'Musim Panen', 'Custom'],
                                onSelected: (filter) {
                                  setState(() => selectedFilter = filter);
                                },
                              ),
                              const SizedBox(height: 16),

                              // === Cards Statistik ===
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: DashboardCard(
                                        imageAsset: 'assets/sehat.png',
                                        number: '112',
                                        label: 'Sehat',
                                        numberColor: AppColors.primaryAuth,
                                        numberFontSize: 36,
                                        numberAreaHeight: 50,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: DashboardCard(
                                        imageAsset: 'assets/busuk.png',
                                        number: '37',
                                        label: 'Busuk',
                                        numberColor: AppColors.redAuth,
                                        numberFontSize: 36,
                                        numberAreaHeight: 50,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: DashboardCard(
                                        imageAsset: 'assets/box.png',
                                        number: '149',
                                        label: 'Total',
                                        numberFontSize: 36,
                                        numberAreaHeight: 50,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Center(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryAuth,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: const Size(
                                      120,
                                      40,
                                    ), // diperlebar sedikit agar muat teks
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // agar button pas mengikuti konten
                                    children: [
                                      Icon(
                                        Icons.download_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Unduh Laporan PDF',
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                              Text(
                                'Riwayat Musim',
                                style: GoogleFonts.rubik(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Scrollbar(
                                thumbVisibility: true, // agar selalu terlihat
                                thickness: 4, // ketebalan indikator
                                radius: const Radius.circular(
                                  8,
                                ), // ujung melengkung
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
                                      inside: const BorderSide(
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
                                      for (var row in seasonHistory)
                                        TableRow(
                                          children: [
                                            CustomTableCell(
                                              text: row['period'],
                                            ),
                                            CustomTableCell(
                                              text: row['healthy'].toString(),
                                            ),
                                            CustomTableCell(
                                              text: row['rotten'].toString(),
                                            ),
                                            CustomTableCell(
                                              text: row['total'].toString(),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
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
