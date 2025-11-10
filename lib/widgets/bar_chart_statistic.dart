import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class BarChartStatistic extends StatelessWidget {
  final Map<int, int> healthyPerMonth;
  final Map<int, int> rottenPerMonth;

  const BarChartStatistic({
    super.key,
    required this.healthyPerMonth,
    required this.rottenPerMonth,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = healthyPerMonth.isNotEmpty || rottenPerMonth.isNotEmpty;

    // Hitung total
    final totalHealthy = healthyPerMonth.values.fold<int>(0, (a, b) => a + b);
    final totalRotten = rottenPerMonth.values.fold<int>(0, (a, b) => a + b);

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Mangga Sehat dan Busuk / Bulan',
              style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Chart
            SizedBox(
              height: 240,
              child: hasData ? _buildChart() : _buildEmptyState(),
            ),

            const SizedBox(height: 8),

            // Legend dengan angka total
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: Colors.green, label: 'Sehat: $totalHealthy'),
                const SizedBox(width: 16),
                _LegendDot(color: Colors.red, label: 'Busuk: $totalRotten'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final months = List.generate(12, (index) => index + 1);

    final maxHealthy = healthyPerMonth.values.isEmpty
        ? 0
        : healthyPerMonth.values.reduce((a, b) => a > b ? a : b);
    final maxRotten = rottenPerMonth.values.isEmpty
        ? 0
        : rottenPerMonth.values.reduce((a, b) => a > b ? a : b);
    final maxY =
        (maxHealthy > maxRotten ? maxHealthy : maxRotten).toDouble() + 5;

    final monthLabels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 10 ? 5 : 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey.shade300, width: 1),
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: maxY > 10 ? 5 : 2,
              getTitlesWidget: (value, _) {
                return Text(
                  value.toInt().toString(),
                  style: GoogleFonts.rubik(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36, // sedikit lebih tinggi biar muat teks miring
              getTitlesWidget: (value, _) {
                final index = value.toInt() - 1;
                if (index < 0 || index >= monthLabels.length) {
                  return const SizedBox();
                }
                return Transform.rotate(
                  angle: -0.6, // sekitar -30 derajat
                  child: Text(
                    monthLabels[index],
                    style: GoogleFonts.rubik(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: months.map((month) {
          return BarChartGroupData(
            x: month,
            barsSpace: 0,
            barRods: [
              BarChartRodData(
                toY: (healthyPerMonth[month] ?? 0).toDouble(),
                color: Colors.green,
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: (rottenPerMonth[month] ?? 0).toDouble(),
                color: Colors.red,
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
        maxY: maxY,
        minY: 0,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 64, color: Colors.grey.shade300),
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
