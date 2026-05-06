import 'dart:async';
import 'dart:convert';

import 'package:usb_serial/usb_serial.dart';

class UsbService {
  UsbPort? _port;

  final StreamController<String> _dataController = StreamController.broadcast();

  Stream<String> get dataStream => _dataController.stream;

  Future<List<UsbDevice>> listDevices() async {
    return await UsbSerial.listDevices();
  }

  Future<bool> connect(UsbDevice device) async {
    _port = await device.create();

    if (!await _port!.open()) {
      return false;
    }

    await _port!.setPortParameters(
      115200,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    _port!.inputStream!.listen((data) {
      final message = utf8.decode(data);

      _dataController.add(message);
    });

    return true;
  }

  void dispose() {
    _port?.close();
  }
}
