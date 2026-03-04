import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/battery_bar_widget.dart';
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

    final widgets = _buildWidgets(vm);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Télémétrie"),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _openSelector(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Sauvegarder les données ?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Non"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Oui"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await context.read<GraphiqueViewModel>().saveData();
              }
            },
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(12), children: widgets),
    );
  }

  List<Widget> _buildWidgets(GraphiqueViewModel vm) {
    final widgets = <Widget>[];

    if (vm.visible["gyro"]!) {
      widgets.add(
        const _GraphCard(
          title: "Gyroscope",
          child: LineGraphWidget(type: GraphType.gyro),
        ),
      );
    }

    if (vm.visible["accel"]!) {
      widgets.add(
        const _GraphCard(
          title: "Accéléromètre",
          child: LineGraphWidget(type: GraphType.accel),
        ),
      );
    }

    if (vm.visible["motors"]!) {
      widgets.add(const _GraphCard(title: "Moteurs", child: MotorBarWidget()));
    }

    if (vm.visible["battery"]!) {
      widgets.add(
        const _GraphCard(title: "Batterie", child: BatteryBarWidget()),
      );
    }

    return widgets;
  }

  void _openSelector(BuildContext context) {
    final vm = context.read<GraphiqueViewModel>();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text("Gyroscope"),
              value: vm.visible["gyro"]!,
              onChanged: (v) => vm.toggle("gyro", v),
            ),
            SwitchListTile(
              title: const Text("Accéléromètre"),
              value: vm.visible["accel"]!,
              onChanged: (v) => vm.toggle("accel", v),
            ),
            SwitchListTile(
              title: const Text("Moteurs"),
              value: vm.visible["motors"]!,
              onChanged: (v) => vm.toggle("motors", v),
            ),
            SwitchListTile(
              title: const Text("Batterie"),
              value: vm.visible["battery"]!,
              onChanged: (v) => vm.toggle("battery", v),
            ),
          ],
        );
      },
    );
  }
}

class _GraphCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _GraphCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onDoubleTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text(title)),
                  body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(height: 220, child: child),
            ],
          ),
        ),
      ),
    );
  }
}
