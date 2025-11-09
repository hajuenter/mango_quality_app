import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class PieChartStatistic extends StatelessWidget {
  final int healthyCount;
  final int rottenCount;

  const PieChartStatistic({
    super.key,
    required this.healthyCount,
    required this.rottenCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = healthyCount + rottenCount;
    final hasData = total > 0;

    final healthyPercent = total > 0 ? (healthyCount / total) * 100 : 0.0;
    final rottenPercent = total > 0 ? (rottenCount / total) * 100 : 0.0;

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Mangga Sehat & Busuk / Hari',
              style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Tampilkan chart atau pesan kosong
            SizedBox(
              height: 200,
              child: hasData
                  ? _buildChart(healthyPercent, rottenPercent)
                  : _buildEmptyState(),
            ),

            const SizedBox(height: 12),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _LegendDot(color: Colors.green, label: 'Mangga Sehat'),
                SizedBox(width: 16),
                _LegendDot(color: Colors.red, label: 'Mangga Busuk'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Chart-nya
  Widget _buildChart(double healthyPercent, double rottenPercent) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        startDegreeOffset: -90,
        sections: [
          PieChartSectionData(
            value: healthyPercent,
            color: Colors.green,
            title: '${healthyPercent.toStringAsFixed(1)}%',
            radius: 60,
            titleStyle: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          PieChartSectionData(
            value: rottenPercent,
            color: Colors.red,
            title: '${rottenPercent.toStringAsFixed(1)}%',
            radius: 60,
            titleStyle: GoogleFonts.rubik(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// Jika tidak ada data
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart_outline_rounded,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            'Tidak ada data',
            style: GoogleFonts.rubik(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Belum ada statistik untuk ditampilkan',
            style: GoogleFonts.rubik(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.rubik(fontSize: 12)),
      ],
    );
  }
}
