import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    final colors = [Colors.blue, Colors.red, Colors.green];

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: -1.5,
        maxY: 1.5,
        lineBarsData: List.generate(lines.length, (i) {
          return LineChartBarData(
            spots: lines[i],
            color: colors[i],
            isCurved: true,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          );
        }),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
      ),
    );
  }
}
