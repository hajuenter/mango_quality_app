import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Mangga Sehat dan Busuk / Bulan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Tampilkan chart atau pesan "Tidak ada data"
            SizedBox(
              height: 220,
              child: hasData ? _buildChart() : _buildEmptyState(),
            ),

            const SizedBox(height: 6),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _LegendDot(color: Colors.green, label: 'Sehat'),
                SizedBox(width: 16),
                _LegendDot(color: Colors.red, label: 'Busuk'),
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
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
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
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                final index = value.toInt() - 1;
                if (index < 0 || index >= monthLabels.length) {
                  return const SizedBox();
                }
                return Text(
                  monthLabels[index],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: months.map((month) {
          return BarChartGroupData(
            x: month,
            barsSpace: 4,
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Belum ada statistik untuk ditampilkan',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
