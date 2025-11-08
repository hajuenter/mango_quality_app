import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartStatistic extends StatelessWidget {
  final Map<int, int> healthyPerYear;
  final Map<int, int> rottenPerYear;

  const LineChartStatistic({
    super.key,
    required this.healthyPerYear,
    required this.rottenPerYear,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = healthyPerYear.isNotEmpty || rottenPerYear.isNotEmpty;

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Mangga Sehat dan Busuk / Tahun',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 220,
              child: hasData ? _buildChart() : _buildEmptyState(),
            ),

            const SizedBox(height: 6),

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
    final allYears = <int>{
      ...healthyPerYear.keys,
      ...rottenPerYear.keys,
    }.toList()..sort();

    if (allYears.isEmpty) {
      return _buildEmptyState();
    }

    final healthySpots = allYears.map((year) {
      final index = allYears.indexOf(year).toDouble();
      final value = (healthyPerYear[year] ?? 0).toDouble();
      return FlSpot(index, value);
    }).toList();

    final rottenSpots = allYears.map((year) {
      final index = allYears.indexOf(year).toDouble();
      final value = (rottenPerYear[year] ?? 0).toDouble();
      return FlSpot(index, value);
    }).toList();

    final maxHealthy = healthyPerYear.values.isEmpty
        ? 0
        : healthyPerYear.values.reduce((a, b) => a > b ? a : b);
    final maxRotten = rottenPerYear.values.isEmpty
        ? 0
        : rottenPerYear.values.reduce((a, b) => a > b ? a : b);
    final maxY =
        (maxHealthy > maxRotten ? maxHealthy : maxRotten).toDouble() + 10;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 20 ? 10 : 5,
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
              reservedSize: 40,
              interval: maxY > 20 ? 10 : 5,
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
                final index = value.toInt();
                if (index < 0 || index >= allYears.length) {
                  return const SizedBox();
                }
                return Text(
                  allYears[index].toString(),
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
        lineBarsData: [
          // Line untuk Mangga Sehat
          LineChartBarData(
            spots: healthySpots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.green,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withAlpha(25),
            ),
          ),
          // Line untuk Mangga Busuk
          LineChartBarData(
            spots: rottenSpots,
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.red,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withAlpha(25),
            ),
          ),
        ],
        maxY: maxY,
        minY: 0,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (LineBarSpot touchedSpot) =>
                Colors.blueGrey.withAlpha(204),
            tooltipPadding: const EdgeInsets.all(8),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final yearIndex = spot.x.toInt();
                final year = allYears[yearIndex];
                final isHealthy = spot.barIndex == 0;

                return LineTooltipItem(
                  '${isHealthy ? 'Sehat' : 'Busuk'}\n$year: ${spot.y.toInt()}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart_rounded, size: 64, color: Colors.grey.shade300),
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
            'Belum ada tren tahunan untuk ditampilkan',
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
