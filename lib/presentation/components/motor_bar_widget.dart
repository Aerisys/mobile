import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/graphique_view_model.dart';

class MotorBarWidget extends StatelessWidget {
  const MotorBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GraphiqueViewModel>();

    return BarChart(
      BarChartData(
        maxY: 100,
        borderData: FlBorderData(show: false),

        barGroups: List.generate(vm.motors.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: vm.motors[i],
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
