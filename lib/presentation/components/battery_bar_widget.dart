import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/graphique_view_model.dart';

class BatteryBarWidget extends StatelessWidget {
  const BatteryBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GraphiqueViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Niveau batterie"),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: vm.battery / 100, minHeight: 20),
        const SizedBox(height: 6),
        Text("${vm.battery.toStringAsFixed(1)} %"),
      ],
    );
  }
}
