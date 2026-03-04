import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphiqueViewModel extends ChangeNotifier {
  final Random _random = Random();

  static const int maxPoints = 30;

  int _time = 0;
  Timer? _timer;

  /// valeur télémétrie
  /// Gyro
  final List<List<FlSpot>> gyro = [[], [], []];

  /// Accéléromètre
  final List<List<FlSpot>> accel = [[], [], []];

  /// moteurs
  final List<double> motors = [0, 0, 0, 0];

  GraphiqueViewModel() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      _generateData();
    });
  }

  void _generateData() {
    _time++;

    _updateLines(gyro);
    _updateLines(accel);

    for (int i = 0; i < motors.length; i++) {
      motors[i] = _random.nextDouble() * 100;
    }

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
