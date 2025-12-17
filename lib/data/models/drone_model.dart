class DroneModel {
  final String id;
  final String name;
  final String modelType;
  final double batteryLevel;
  final String status;

  DroneModel({
    required this.id,
    required this.name,
    required this.modelType,
    required this.batteryLevel,
    required this.status,
  });

  factory DroneModel.fromMap(String id, Map<String, dynamic> data) {
    return DroneModel(
      id: id,
      name: data['name'] ?? 'Unknown Drone',
      modelType: data['modelType'] ?? 'Standard',
      batteryLevel: (data['batteryLevel'] ?? 0).toDouble(),
      status: data['status'] ?? 'Offline',
    );
  }
}