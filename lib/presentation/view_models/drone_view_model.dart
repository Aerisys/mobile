import 'package:mobile/data/models/drone_model.dart';
import 'common_view_model.dart';

class DroneViewModel extends CommonViewModel {
  List<DroneModel> _drones = [];
  List<DroneModel> get drones => _drones;

  DroneModel? _selectedDrone;
  DroneModel? get selectedDrone => _selectedDrone;

  void selectDrone(DroneModel drone) {
    _selectedDrone = drone;
    notifyListeners();
  }

  void fetchDrones() async {
    isLoading = true;

    // Simulate a network delay for Firebase
    await Future.delayed(const Duration(seconds: 1));

    // FAKE DATA for testing
    _drones = [
      DroneModel(id: '1', name: 'Alpha-X', modelType: 'DJI Mavic', batteryLevel: 85, status: 'Disconnected'),
      DroneModel(id: '2', name: 'Sky-Knight', modelType: 'Parrot Anafi', batteryLevel: 12, status: 'Charging'),
      DroneModel(id: '3', name: 'Bro-Flyer', modelType: 'Custom Build', batteryLevel: 45, status: 'Disconnected'),
      DroneModel(id: '4', name: 'Super drone 3000', modelType: 'DJI Mavic', batteryLevel: 78, status: 'Connected'),
    ];
    
    if (_selectedDrone == null && _drones.isNotEmpty) {
      _selectedDrone = _drones.last; // Default to 'Super drone 3000'
    }

    isLoading = false;
  }
}