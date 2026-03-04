import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MotorBarWidget extends StatelessWidget {
  final List<double> motors;

  const MotorBarWidget({super.key, required this.motors});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: 100,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
        barGroups: List.generate(motors.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: motors[i].clamp(0, 100),
                width: 16,
                color: Colors.orange,
              ),
            ],
          );
        }),
      ),
    );
  }
}
