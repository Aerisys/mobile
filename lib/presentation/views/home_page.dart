import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/drone_model.dart';
import '../../data/models/dashboard_widget_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_colors.dart';
import '../components/atoms/aerisys_icon.dart';
import '../components/molecules/aerisys_top_bar.dart';
import '../components/molecules/drone_preview.dart';
import '../components/molecules/drone_preview.dart';
import '../components/organisms/speed_chart_dialog.dart';
import '../components/organisms/rpm_chart_dialog.dart';
import '../components/organisms/pressure_chart_dialog.dart';
import '../view_models/dashboard_view_model.dart';
import '../view_models/drone_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final droneViewModel = context.watch<DroneViewModel>();
    final activeDrone = droneViewModel.selectedDrone ?? DroneModel(
      id: '0',
      name: 'Aucun appareil',
      modelType: '-',
      batteryLevel: 0,
      status: 'Inconnu',
    );

    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
          child: Column(
            children: [
              AerisysTopBar(title: activeDrone.name),
              const SizedBox(height: 30),
              DronePreview(drone: activeDrone),
              const SizedBox(height: 30),
              
              if (viewModel.topSlot != null) ...[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (viewModel.topSlot == DashboardWidgetType.battery) {
                        context.push(AppRoutes.battery, extra: activeDrone);
                      } else if (viewModel.topSlot == DashboardWidgetType.speed) {
                        showDialog(
                          context: context,
                          builder: (context) => const SpeedChartDialog(),
                        );
                      } else if (viewModel.topSlot == DashboardWidgetType.droneState) {
                        showDialog(
                          context: context,
                          builder: (context) => const RpmChartDialog(),
                        );
                      } else if (viewModel.topSlot == DashboardWidgetType.pressure) {
                        showDialog(
                          context: context,
                          builder: (context) => const PressureChartDialog(),
                        );
                      }
                    },
                    child: IgnorePointer(
                      ignoring: true,
                      child: _buildDynamicWideWidget(viewModel.topSlot!, activeDrone),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: viewModel.smallSlots.length,
                itemBuilder: (context, index) {
                  final type = viewModel.smallSlots[index];
                  if (type == null) return const SizedBox.shrink();
                  
                  Widget item = _buildStatItem(
                    icon: type.icon,
                    title: type.name,
                    value: _getDummyValueFor(type),
                  );
                  
                  if (type == DashboardWidgetType.speed) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SpeedChartDialog(),
                          );
                        },
                        child: IgnorePointer(
                          ignoring: true, // Let InkWell handle the tap
                          child: item,
                        ),
                      ),
                    );
                  } else if (type == DashboardWidgetType.droneState) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const RpmChartDialog(),
                          );
                        },
                        child: IgnorePointer(
                          ignoring: true,
                          child: item,
                        ),
                      ),
                    );
                  } else if (type == DashboardWidgetType.pressure) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const PressureChartDialog(),
                          );
                        },
                        child: IgnorePointer(
                          ignoring: true,
                          child: item,
                        ),
                      ),
                    );
                  }
                  
                  return item;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryCard(int batteryLevel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Batterie',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkSlate,
                ),
              ),
              Text(
                '$batteryLevel%',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: batteryLevel / 100,
              minHeight: 10,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkSlate),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.speed,
            title: 'Vitesse',
            value: '58km/h',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            icon: Icons.location_on_outlined,
            title: 'Distance',
            value: '15km',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            icon: Icons.air,
            title: 'Vent',
            value: '15km/h',
            subtitle: '10pm',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF6F7F9),
              shape: BoxShape.circle,
            ),
            child: AerisysIcon(icon, color: AppColors.darkSlate, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.darkSlate,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.darkSlate,
              ),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ]
        ],
      ),
    );
  }

  String _getDummyValueFor(DashboardWidgetType type) {
    switch (type) {
      case DashboardWidgetType.pressure: return '1022hPa';
      case DashboardWidgetType.speed: return '58km/h';
      case DashboardWidgetType.distance: return '15km';
      case DashboardWidgetType.wind: return '15km/h';
      case DashboardWidgetType.cpu: return '45°C';
      case DashboardWidgetType.droneState: return 'OK';
      case DashboardWidgetType.altitude: return '120m';
      case DashboardWidgetType.flightTime: return '22min';
      case DashboardWidgetType.videoTime: return '12:30';
      case DashboardWidgetType.motor1:
      case DashboardWidgetType.motor2:
      case DashboardWidgetType.motor3:
      case DashboardWidgetType.motor4: return '3200rpm';
      case DashboardWidgetType.battery: return '85%';
    }
  }

  Widget _buildDynamicWideWidget(DashboardWidgetType type, DroneModel drone) {
    if (type == DashboardWidgetType.battery) {
      return _buildBatteryCard(drone.batteryLevel.toInt());
    } else if (type == DashboardWidgetType.videoTime) {
      return _buildRecordingCard();
    }
    
    // Generic wide widget
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: AerisysIcon(type.icon, color: AppColors.darkSlate, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkSlate,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getDummyValueFor(type),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkSlate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const AerisysIcon(Icons.videocam_outlined, color: AppColors.darkSlate, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Temps d'enregistrement",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkSlate,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: const [
                    Text(
                      '12:30:21',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkSlate,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'hrs',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.7,
                    minHeight: 10,
                    backgroundColor: Color(0xFFF3F4F6),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkSlate),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}