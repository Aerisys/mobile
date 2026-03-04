import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class GraphiqueViewModel extends ChangeNotifier {
  final Random _random = Random();
  static const int maxPoints = 30;

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

  GraphiqueViewModel() {
    _initDataset(gyro);
    _initDataset(accel);
    _startSimulation();
  }

  void _initDataset(List<List<FlSpot>> dataset) {
    for (final line in dataset) {
      line.add(const FlSpot(0, 0));
    }
  }

  void toggle(String key, bool value) {
    visible[key] = value;
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final String item = order.removeAt(oldIndex);
    order.insert(newIndex, item);
    notifyListeners();
  }

  void _startSimulation() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => _generateData(),
    );
  }

  void _generateData() {
    _time++;
    _updateLines(gyro);
    _updateLines(accel);
    for (int i = 0; i < motors.length; i++) {
      motors[i] = _random.nextDouble() * 100;
    }
    battery = (battery - 0.1).clamp(0, 100); // Simulation décharge
    notifyListeners();
  }

  void _updateLines(List<List<FlSpot>> dataset) {
    for (final line in dataset) {
      line.add(FlSpot(_time.toDouble(), (_random.nextDouble() * 2) - 1));
      if (line.length > maxPoints) line.removeAt(0);
    }
  }

  double get minX => _time > maxPoints ? (_time - maxPoints).toDouble() : 0;
  double get maxX => _time.toDouble();

  Future<String> saveData() async {
    final dir = await getApplicationDocumentsDirectory();
    final String timestamp = DateTime.now().toIso8601String();
    final file = File(
      "${dir.path}/telemetry_${DateTime.now().millisecondsSinceEpoch}.csv",
    );

    final buffer = StringBuffer();
    buffer.writeln("Timestamp,Type,Axis_0,Axis_1,Axis_2,Battery");

    buffer.write("$timestamp,DATA,");
    buffer.write("${gyro[0].last.y},${gyro[1].last.y},${gyro[2].last.y},");
    buffer.writeln("$battery");

    await file.writeAsString(buffer.toString());
    return file.path;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
