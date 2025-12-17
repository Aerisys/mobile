import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../view_models/drone_view_model.dart';

class DroneListPage extends StatefulWidget {
  const DroneListPage({super.key});

  @override
  State<DroneListPage> createState() => _DroneListPageState();
}

class _DroneListPageState extends State<DroneListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DroneViewModel>().fetchDrones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Drones")),
      body: Consumer<DroneViewModel>(
        builder: (context, model, child) {
          if (model.isLoading) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: model.drones.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final drone = model.drones[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.airplanemode_active, color: Colors.blue),
                  title: Text(drone.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${drone.modelType} • ${drone.status}"),
                  trailing: Text("${drone.batteryLevel.toInt()}%"),
                  onTap: () {
                    // I will set this up next: navigate to details
                    context.push('/drone/details', extra: drone);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}