import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphiqueViewModel extends ChangeNotifier {
  final Random _random = Random();

  final List<List<FlSpot>> _lines = [];

  List<List<FlSpot>> get lines => _lines;

  int _time = 0;
  Timer? _timer;

  GraphiqueViewModel() {
    _init();
  }

  void _init() {
    addLine();
    addLine();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _generateData();
    });
  }

  void addLine() {
    _lines.add([FlSpot(_time.toDouble(), _random.nextDouble() * 10)]);
    notifyListeners();
  }

  void _generateData() {
    _time++;

    for (int i = 0; i < _lines.length; i++) {
      final value = _random.nextDouble() * 10;
      _lines[i].add(FlSpot(_time.toDouble(), value));

      if (_lines[i].length > 50) {
        _lines[i].removeAt(0);
      }
    }

    notifyListeners();
  }

  List<LineChartBarData> buildChartLines() {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return List.generate(_lines.length, (index) {
      return LineChartBarData(
        spots: _lines[index],
        isCurved: true,
        barWidth: 3,
        color: colors[index % colors.length],
        dotData: const FlDotData(show: false),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
