import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:presenter_2/main.dart';




control() async {

  if (await Permission.bluetoothScan.request().isGranted) {
    // Permission is granted
    // Start scanning for Bluetooth devices
  } else {
    // Permission is denied
    // Show an error message or request the permission again
  }

  if (await Permission.bluetoothConnect.request().isGranted) {
    // Permission is granted
    // Start scanning for Bluetooth devices
  } else {
    // Permission is denied
    // Show an error message or request the permission again
  }

  FlutterBlue flutterBlue = FlutterBlue.instance;
  // Find and connect to the target device
  // Start scanning
  //flutterBlue.startScan(timeout: const Duration(seconds: 4));

  logger.i("Scan started");

  // Listen to scan results
  flutterBlue.scanResults.listen((results) async {
    logger.i("aiting");
    for (ScanResult r in results) {
      logger.i(r.device.name);
      //_device ??= r.device;
    }
  });
  /*final BluetoothDevice _device = ( await flutterBlue.scan().firstWhere((ScanResult result) => result.device.name == "TAVYBOOK") ).device;

  logger.i(_device);
  await _device.connect();

  // Discover the HID service and characteristics
  final services = await _device.discoverServices();
  logger.i(services);
  final hidService = services.firstWhere((s) => s.uuid == Guid('00001812-0000-1000-8000-00805f9b34fb'));
  final inputChar = hidService.characteristics.firstWhere((c) => c.uuid == Guid('00002a22-0000-1000-8000-00805f9b34fb'));

  // Send a keyboard input message
  final message = [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00];
  await inputChar.write(message, withoutResponse: true);*/
}