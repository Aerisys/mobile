import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum GraphType { gyro, accel }

class LineGraphWidget extends StatelessWidget {
  final List<List<FlSpot>> lines;
  final double minX;
  final double maxX;

  const LineGraphWidget({
    super.key,
    required this.lines,
    required this.minX,
    required this.maxX,
  });

  @override
  Widget build(BuildContext context) {
    // évite le crash mostLeftSpot si jamais
    if (lines.isEmpty || lines.every((l) => l.isEmpty)) {
      return const Center(child: Text("En attente de données"));
    }

    final colors = [Colors.blue, Colors.red, Colors.green];

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: -1.5,
        maxY: 1.5,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: List.generate(lines.length, (i) {
          final spots = lines[i];
          // ne jamais donner une liste vide à fl_chart
          if (spots.isEmpty) {
            return LineChartBarData(
              spots: const [FlSpot(0, 0)],
              color: colors[i % colors.length],
              dotData: const FlDotData(show: false),
            );
          }

          return LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2,
            color: colors[i % colors.length],
            dotData: const FlDotData(show: false),
          );
        }),
      ),
    );
  }
}
