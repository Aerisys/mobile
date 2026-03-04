import 'package:flutter/material.dart';

class BatteryBarWidget extends StatelessWidget {
  final double battery; // 0..100

  const BatteryBarWidget({super.key, required this.battery});

  @override
  Widget build(BuildContext context) {
    final v = (battery.clamp(0, 100)) / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Niveau batterie"),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: v, minHeight: 20),
        const SizedBox(height: 6),
        Text("${battery.toStringAsFixed(1)} %"),
      ],
    );
  }
}
