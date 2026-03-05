class TelemetryPoint {
  final int? id;
  final int timestamp;
  final String type; // "gyro" ou "accel"
  final double x;
  final double y;
  final double z;

  TelemetryPoint({
    this.id,
    required this.timestamp,
    required this.type,
    required this.x,
    required this.y,
    required this.z,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'timestamp': timestamp,
      'type': type,
      'x': x,
      'y': y,
      'z': z,
    };
  }

  factory TelemetryPoint.fromMap(Map<String, dynamic> map) {
    return TelemetryPoint(
      id: map['id'] as int?,
      timestamp: map['timestamp'] as int,
      type: map['type'] as String,
      x: (map['x'] as num).toDouble(),
      y: (map['y'] as num).toDouble(),
      z: (map['z'] as num).toDouble(),
    );
  }
}
