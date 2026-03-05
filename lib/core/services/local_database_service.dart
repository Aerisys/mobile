import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/models/telemetry_model.dart';

class LocalDatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'drone_telemetry.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE drones(
            id TEXT PRIMARY KEY, name TEXT, modelType TEXT, batteryLevel REAL, status TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE telemetry(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp INTEGER, type TEXT, x REAL, y REAL, z REAL
          )
        ''');
      },
    );
  }

  Future<void> saveTelemetry(TelemetryPoint point) async {
    final db = await database;
    await db.insert('telemetry', point.toMap());
  }

  Future<List<TelemetryPoint>> getRecentTelemetry(
    String type,
    int limit,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'telemetry',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return maps
        .map((m) => TelemetryPoint.fromMap(m))
        .toList()
        .reversed
        .toList();
  }
}
