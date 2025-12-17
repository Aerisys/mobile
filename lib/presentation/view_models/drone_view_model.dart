import 'package:mobile/data/models/drone_model.dart';
import 'common_view_model.dart';

class DroneViewModel extends CommonViewModel {
  List<DroneModel> _drones = [];
  List<DroneModel> get drones => _drones;

  void fetchDrones() async {
    isLoading = true;

    // Simulate a network delay for Firebase
    await Future.delayed(const Duration(seconds: 1));

    // FAKE DATA for testing
    _drones = [
      DroneModel(id: '1', name: 'Alpha-X', modelType: 'DJI Mavic', batteryLevel: 85, status: 'Idle'),
      DroneModel(id: '2', name: 'Sky-Knight', modelType: 'Parrot Anafi', batteryLevel: 12, status: 'Charging'),
      DroneModel(id: '3', name: 'Bro-Flyer', modelType: 'Custom Build', batteryLevel: 45, status: 'Flying'),
    ];

    isLoading = false;
  }
}