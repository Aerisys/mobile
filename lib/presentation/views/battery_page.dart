import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../data/models/drone_model.dart';
import '../components/molecules/aerisys_top_bar.dart';
import '../components/molecules/drone_preview.dart';
import '../components/molecules/drone_preview.dart';

class BatteryPage extends StatelessWidget {
  final DroneModel drone;

  const BatteryPage({super.key, required this.drone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
          child: Column(
            children: [
              AerisysTopBar(title: drone.name),
              const SizedBox(height: 30),
              DronePreview(drone: drone),
              const SizedBox(height: 30),
              _buildBatteryChartCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Batterie',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.darkSlate,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Consommation de batterie dans le temps',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 250,
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    const Color curveColor = Color(0xFF2E6FF2); // Standard vivid blue

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 5, // 0 to 5 mapped to 0s -> 2m30s (steps of 30s)
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.2),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const labels = ['0s', '30s', '1m0s', '1m30s', '2m0s', '2m30s'];
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Text(
                        labels[value.toInt()],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\${value.toInt()}%',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.white,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  'Niveau de batterie\n',
                  const TextStyle(
                    color: AppColors.darkSlate,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  children: const [
                    TextSpan(
                      text: '1m21s (14h31) : ', // Hardcoded mock to match the exact image
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    TextSpan(
                      text: '85%', // Matching the mock drone status
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 100),
              FlSpot(0.5, 98),
              FlSpot(1, 95),
              FlSpot(1.5, 85),
              FlSpot(2, 80),
              FlSpot(2.5, 75),
              FlSpot(3, 70),
              FlSpot(3.5, 65),
              FlSpot(4, 55),
              FlSpot(4.5, 45),
              FlSpot(5, 20),
            ],
            isCurved: true,
            color: curveColor,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  curveColor.withValues(alpha: 0.4),
                  curveColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
