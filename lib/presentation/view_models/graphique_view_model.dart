import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class GraphiqueViewModel extends ChangeNotifier {
  final Random _random = Random();

  static const int maxPoints = 30;

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

    battery = 30 + _random.nextDouble() * 70;

    notifyListeners();
  }

  void _updateLines(List<List<FlSpot>> dataset) {
    for (final line in dataset) {
      line.add(FlSpot(_time.toDouble(), (_random.nextDouble() * 2) - 1));

      if (line.length > maxPoints) {
        line.removeAt(0);
      }
    }
  }

  double get minX => _time > maxPoints ? (_time - maxPoints).toDouble() : 0;

  double get maxX => _time.toDouble();

  Future<void> saveData() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      "${dir.path}/telemetry_${DateTime.now().millisecondsSinceEpoch}.txt",
    );

    final buffer = StringBuffer();

    for (final line in gyro) {
      for (final p in line) {
        buffer.writeln("gyro ${p.x} ${p.y}");
      }
    }

    for (final line in accel) {
      for (final p in line) {
        buffer.writeln("accel ${p.x} ${p.y}");
      }
    }

    buffer.writeln("battery $battery");

    await file.writeAsString(buffer.toString());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
