import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/graphique_view_model.dart';

enum GraphType { gyro, accel }

class LineGraphWidget extends StatelessWidget {
  final GraphType type;

  const LineGraphWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GraphiqueViewModel>();

    final data = type == GraphType.gyro ? vm.gyro : vm.accel;

    final colors = [Colors.blue, Colors.red, Colors.green];

    return LineChart(
      LineChartData(
        minX: vm.minX,
        maxX: vm.maxX,
        minY: -1.5,
        maxY: 1.5,

        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),

        lineBarsData: List.generate(data.length, (i) {
          return LineChartBarData(
            spots: data[i],
            isCurved: true,
            barWidth: 2,
            color: colors[i],
            dotData: const FlDotData(show: false),
          );
        }),
      ),
    );
  }
}
