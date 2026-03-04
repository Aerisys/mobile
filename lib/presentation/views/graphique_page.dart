import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/graphique_view_model.dart';

class GraphiquePage extends StatelessWidget {
  const GraphiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GraphiqueViewModel(),
      child: const _GraphiqueView(),
    );
  }
}

class _GraphiqueView extends StatelessWidget {
  const _GraphiqueView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GraphiqueViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Graphiques temps réel")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GraphiqueViewModel>().addLine();
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            minX: 0,
            minY: 0,
            maxY: 10,

            lineBarsData: viewModel.buildChartLines(),

            gridData: FlGridData(show: true),

            borderData: FlBorderData(show: false),

            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),

            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
