import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/line_graph_widget.dart';
import '../components/motor_bar_widget.dart';
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
    final vm = context.watch<GraphiqueViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Telemetry")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: LineGraphWidget(
                lines: vm.gyro,
                minX: vm.minX,
                maxX: vm.maxX,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: LineGraphWidget(
                lines: vm.accel,
                minX: vm.minX,
                maxX: vm.maxX,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(height: 200, child: MotorBarWidget(motors: vm.motors)),
          ],
        ),
      ),
    );
  }
}
