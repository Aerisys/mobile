import 'package:flutter/material.dart';

enum DashboardWidgetType {
  battery,
  cpu,
  droneState,
  motor1,
  altitude,
  wind,
  motor2,
  flightTime,
  motor4,
  speed,
  motor3,
  distance,
  pressure,
  videoTime,
}

extension DashboardWidgetTypeExtension on DashboardWidgetType {
  String get name {
    switch (this) {
      case DashboardWidgetType.battery: return "Batterie";
      case DashboardWidgetType.cpu: return "Cpu";
      case DashboardWidgetType.droneState: return "Etat du drone";
      case DashboardWidgetType.motor1: return "Moteur 1";
      case DashboardWidgetType.altitude: return "Altitude";
      case DashboardWidgetType.wind: return "Vent";
      case DashboardWidgetType.motor2: return "Moteur 2";
      case DashboardWidgetType.flightTime: return "Durée de vol";
      case DashboardWidgetType.motor4: return "Moteur 4";
      case DashboardWidgetType.speed: return "Vitesse";
      case DashboardWidgetType.motor3: return "Moteur 3";
      case DashboardWidgetType.distance: return "Distance";
      case DashboardWidgetType.pressure: return "Pression";
      case DashboardWidgetType.videoTime: return "Durée du film";
    }
  }

  IconData get icon {
    switch (this) {
      case DashboardWidgetType.battery: return Icons.battery_charging_full;
      case DashboardWidgetType.cpu: return Icons.memory;
      case DashboardWidgetType.droneState: return Icons.gamepad_outlined;
      case DashboardWidgetType.motor1: return Icons.air;
      case DashboardWidgetType.altitude: return Icons.terrain_outlined;
      case DashboardWidgetType.wind: return Icons.air_outlined;
      case DashboardWidgetType.motor2: return Icons.air;
      case DashboardWidgetType.flightTime: return Icons.timer_outlined;
      case DashboardWidgetType.motor4: return Icons.air;
      case DashboardWidgetType.speed: return Icons.speed;
      case DashboardWidgetType.motor3: return Icons.air;
      case DashboardWidgetType.distance: return Icons.location_on_outlined;
      case DashboardWidgetType.pressure: return Icons.compress;
      case DashboardWidgetType.videoTime: return Icons.videocam_outlined;
    }
  }
}
