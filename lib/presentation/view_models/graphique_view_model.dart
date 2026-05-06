import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/services/local_database_service.dart';
import '../../data/models/dashboard_settings.dart';
import '../../data/models/telemetry_model.dart';

class GraphiqueViewModel extends ChangeNotifier {
  final LocalDatabaseService _localDb;
  final DashboardSettingsRepository _repository;

  final Random _random = Random();
  static const int maxPoints = 30;
  bool _isDisposed = false;

  final List<String> order = ["gyro", "accel", "motors", "battery"];
  final Map<String, bool> visible = {
    "gyro": true,
    "accel": true,
    "motors": true,
    "battery": true,
  };

  final List<List<FlSpot>> gyro = [[], [], []];
  final List<List<FlSpot>> accel = [[], [], []];
  final List<double> motors = [0, 0, 0, 0];
  double battery = 100;

  int _time = 0;
  Timer? _timer;

  GraphiqueViewModel(this._localDb, this._repository) {
    _setup();
  }

  /// Initialisation complète et ordonnée
  Future<void> _setup() async {
    _initDataset(gyro);
    _initDataset(accel);

    _loadHistoryFromLocal();
    _startSimulation();
    try {
      await loadUserConfig().timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint("Firebase non disponible, on continue en local : $e");
    }
  }

  void _initDataset(List<List<FlSpot>> dataset) {
    for (final line in dataset) {
      line.clear();
      line.add(const FlSpot(0, 0));
    }
  }

  /// Récupère les derniers points en base pour remplir le graphique au démarrage
  Future<void> _loadHistoryFromLocal() async {
    try {
      final history = await _localDb.getRecentTelemetry("gyro", maxPoints);
      if (history.isNotEmpty && !_isDisposed) {
        gyro[0].clear();
        gyro[1].clear();
        gyro[2].clear();

        for (var point in history) {
          _time++; // On synchronise le temps avec le nombre de points
          gyro[0].add(FlSpot(_time.toDouble(), point.x));
          gyro[1].add(FlSpot(_time.toDouble(), point.y));
          gyro[2].add(FlSpot(_time.toDouble(), point.z));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erreur chargement historique local: $e");
    }
  }

  void _startSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => _generateData(),
    );
  }

  Future<void> _generateData() async {
    if (_isDisposed) return;

    _time++;

    final point = TelemetryPoint(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      type: "gyro",
      x: (_random.nextDouble() * 2) - 1,
      y: (_random.nextDouble() * 2) - 1,
      z: (_random.nextDouble() * 2) - 1,
    );

    await _localDb.saveTelemetry(point);

    if (!_isDisposed) {
      gyro[0].add(FlSpot(_time.toDouble(), point.x));
      gyro[1].add(FlSpot(_time.toDouble(), point.y));
      gyro[2].add(FlSpot(_time.toDouble(), point.z));

      for (var axis in gyro) {
        if (axis.length > maxPoints) axis.removeAt(0);
      }

      for (int i = 0; i < motors.length; i++) {
        motors[i] = _random.nextDouble() * 100;
      }
      battery = (battery - 0.1).clamp(0, 100);

      notifyListeners();
    }
  }

  // --- Getters pour les graphiques ---
  double get minX => _time > maxPoints ? (_time - maxPoints).toDouble() : 0;
  double get maxX => _time.toDouble();

  // --- Gestion de la configuration (Firebase) ---

  Future<void> loadUserConfig() async {
    try {
      final data = await _repository.userDashboardRef().get();
      if (_isDisposed) return;

      if (data.exists && data.data() != null) {
        final config = data.data()!;
        if (config['visible'] != null) {
          visible.addAll(Map<String, bool>.from(config['visible']));
        }
        if (config['order'] != null) {
          order.clear();
          order.addAll(List<String>.from(config['order']));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erreur chargement config distant: $e");
    }
  }

  Future<void> syncConfigToFirebase() async {
    await _repository.saveUserDashboard(visible: visible, order: order);
  }

  void toggle(String key, bool value) {
    visible[key] = value;
    notifyListeners();
    syncConfigToFirebase();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final String item = order.removeAt(oldIndex);
    order.insert(newIndex, item);
    notifyListeners();
    syncConfigToFirebase();
  }

  // --- Exportation et cycle de vie ---

  Future<String> saveData() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      "${dir.path}/telemetry_${DateTime.now().millisecondsSinceEpoch}.csv",
    );

    final buffer = StringBuffer();
    buffer.writeln("Timestamp,Type,Gyro_X,Gyro_Y,Gyro_Z,Battery");
    buffer.write("${DateTime.now().toIso8601String()},DATA,");
    buffer.write("${gyro[0].last.y},${gyro[1].last.y},${gyro[2].last.y},");
    buffer.writeln("$battery");

    await file.writeAsString(buffer.toString());
    return file.path;
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
