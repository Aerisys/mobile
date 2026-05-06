import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di.dart';
import '../../core/services/usb_service.dart';
import '../components/battery_bar_widget.dart';
import '../components/line_graph_widget.dart';
import '../components/motor_bar_widget.dart';
import '../view_models/graphique_view_model.dart';
import 'esp32_test_page.dart';

class GraphiquePage extends StatelessWidget {
  const GraphiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<GraphiqueViewModel>(),
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
      appBar: AppBar(
        title: const Text("Télémétrie Drone"),
        actions: [
          IconButton(
            icon: const Icon(Icons.usb),
            onPressed: () async {
              final usb = getIt<UsbService>();

              final devices = await usb.listDevices();

              if (devices.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Aucun périphérique USB")),
                );
                return;
              }

              await usb.connect(devices.first);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("USB connecté")));
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _openSelector(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final path = await vm.saveData();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("CSV sauvegardé dans : $path")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.developer_board),
            tooltip: "Test ESP32",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Esp32TestPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// panneau debug USB
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.black87,
            child: StreamBuilder<String>(
              stream: getIt<UsbService>().dataStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    "USB : aucune donnée",
                    style: TextStyle(color: Colors.white),
                  );
                }

                return Text(
                  "USB DATA : ${snapshot.data}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontFamily: "monospace",
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.all(12),
              onReorder: vm.reorder,
              children: vm.order
                  .where((key) => vm.visible[key]!)
                  .map((key) => _buildCard(key, vm))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String key, GraphiqueViewModel vm) {
    switch (key) {
      case "gyro":
        return _GraphCard(
          key: const ValueKey("gyro"),
          title: "Gyroscope",
          child: LineGraphWidget(lines: vm.gyro, minX: vm.minX, maxX: vm.maxX),
        );

      case "accel":
        return _GraphCard(
          key: const ValueKey("accel"),
          title: "Accéléromètre",
          child: LineGraphWidget(lines: vm.accel, minX: vm.minX, maxX: vm.maxX),
        );

      case "motors":
        return _GraphCard(
          key: const ValueKey("motors"),
          title: "Moteurs",
          child: MotorBarWidget(motors: vm.motors),
        );

      case "battery":
        return _GraphCard(
          key: const ValueKey("battery"),
          title: "Batterie",
          child: BatteryBarWidget(battery: vm.battery),
        );

      default:
        return SizedBox(key: ValueKey(key));
    }
  }

  void _openSelector(BuildContext context) {
    final vm = context.read<GraphiqueViewModel>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: vm,
          child: Consumer<GraphiqueViewModel>(
            builder: (context, currentVm, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Affichage des graphiques",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text("Gyroscope"),
                      value: currentVm.visible["gyro"]!,
                      onChanged: (v) => currentVm.toggle("gyro", v),
                    ),
                    SwitchListTile(
                      title: const Text("Accéléromètre"),
                      value: currentVm.visible["accel"]!,
                      onChanged: (v) => currentVm.toggle("accel", v),
                    ),
                    SwitchListTile(
                      title: const Text("Moteurs"),
                      value: currentVm.visible["motors"]!,
                      onChanged: (v) => currentVm.toggle("motors", v),
                    ),
                    SwitchListTile(
                      title: const Text("Batterie"),
                      value: currentVm.visible["battery"]!,
                      onChanged: (v) => currentVm.toggle("battery", v),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _GraphCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _GraphCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onDoubleTap: () {
          final vm = context.read<GraphiqueViewModel>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: vm,
                child: Scaffold(
                  appBar: AppBar(title: Text(title)),
                  body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Icon(Icons.drag_handle, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(height: 200, child: child),
            ],
          ),
        ),
      ),
    );
  }
}
