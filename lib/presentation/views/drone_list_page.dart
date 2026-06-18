import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';
import '../view_models/drone_view_model.dart';
import '../components/molecules/aerisys_top_bar.dart';

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
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: AerisysTopBar(
                title: 'Mes Drones',
                onBack: () => context.go(AppRoutes.appareils),
              ),
            ),
            Expanded(
              child: Consumer<DroneViewModel>(
                builder: (context, model, child) {
                  if (model.isLoading) return const Center(child: CircularProgressIndicator());

                  return ListView.builder(
                    itemCount: model.drones.length,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                    itemBuilder: (context, index) {
                      final drone = model.drones[index];
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Image.asset(AppAssets.droneDji, height: 40, fit: BoxFit.contain),
                          title: Text(drone.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkSlate)),
                          subtitle: Text("${drone.modelType} • ${drone.status}", style: const TextStyle(color: Colors.grey)),
                          trailing: Text("${drone.batteryLevel.toInt()}%", style: const TextStyle(color: AppColors.darkSlate, fontWeight: FontWeight.bold)),
                          onTap: () {
                            model.selectDrone(drone);
                            context.push(AppRoutes.home);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}