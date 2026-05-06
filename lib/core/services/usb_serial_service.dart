import 'dart:async';
import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

/// Service singleton pour la communication USB série avec l'ESP32.
/// Utilise le package usb_serial (Android uniquement).
class UsbSerialService {
  UsbSerialService._internal();
  static final UsbSerialService instance = UsbSerialService._internal();

  UsbPort? _port;
  StreamSubscription? _subscription;

  final StreamController<String> _messageController =
      StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  /// Recherche l'ESP32 parmi les devices USB et ouvre la connexion.
  /// Retourne true si la connexion et le handshake ping/pong réussissent.
  Future<bool> connect() async {
    try {
      final devices = await UsbSerial.listDevices();
      if (devices.isEmpty) return false;

      // On prend le premier device disponible (CH340, CP2102, etc.)
      final device = devices.first;
      _port = await device.create();

      final opened = await _port!.open();
      if (!opened) return false;

      await _port!.setDTR(true);
      await _port!.setRTS(true);
      await _port!.setPortParameters(
        115200,
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );

      String buffer = "";

      _subscription = _port!.inputStream!.listen((Uint8List data) {
        final chunk = String.fromCharCodes(data);

        // debug visible UI
        _messageController.add("RAW >>> $chunk");

        buffer += chunk;

        while (buffer.contains('\n')) {
          final index = buffer.indexOf('\n');
          final line = buffer.substring(0, index).trim();
          buffer = buffer.substring(index + 1);

          if (line.isNotEmpty) {
            _messageController.add("PARSED >>> $line");
          }
        }
      });

      // Handshake ping/pong avec timeout
      final completer = Completer<bool>();
      late StreamSubscription sub;
      sub = messageStream.listen((msg) {
        final ok =
            msg.contains('pong') ||
            msg.contains('CONN_ALIVE') ||
            msg.contains('JOY_DATA') ||
            msg.contains('DEBUG,');

        if (ok && !completer.isCompleted) {
          completer.complete(true);
          sub.cancel();
        }
      });

      await send('ping');

      final success = await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );

      if (!success) {
        await disconnect();
        return false;
      }

      _isConnected = true;
      _connectionController.add(true);
      return true;
    } catch (_) {
      await disconnect();
      return false;
    }
  }

  /// Envoie une chaîne de caractères à l'ESP32.
  Future<void> send(String message) async {
    if (_port == null) return;
    await _port!.write(Uint8List.fromList('$message\n'.codeUnits));
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    await _port?.close();
    _port = null;
    _isConnected = false;
    _connectionController.add(false);
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _connectionController.close();
  }
}
