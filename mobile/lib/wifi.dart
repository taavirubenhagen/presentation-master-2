import 'dart:async';
import "package:http/http.dart" as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';

import 'package:presentation_master_2/main.dart';




enum ControlAction {
  ping,
  start,
  forward,
  back,
  mousemove,
}
Map<ControlAction, String> controlRoutes = {
  ControlAction.ping: "",
  ControlAction.start: "start",
  ControlAction.forward: "forward",
  ControlAction.back: "back",
  ControlAction.mousemove: "mouse",
};




StreamSubscription<NetworkAddress>? _scanningSubscription;

void _resetScanningSubscription(context) async {
  _scanningSubscription?.cancel();
  _scanningSubscription = null;
}

void _initReconnecting(context) async {
  // TODO: Does it work?
  PresentationMaster2.setAppState(context, () => serverIP = null);
  serverIP = null;
  await Future.delayed(const Duration(seconds: 1));
  connect(context);
}

Future<void> connect(context) async {
  logger.i("Starting network scan");
  final String? deviceIP = await NetworkInfo().getWifiIP();
  logger.v('Device IP: $deviceIP');
  final String? subnet = deviceIP?.substring(0, deviceIP.lastIndexOf('.'));
  logger.v('Subnet: $subnet');
  if (subnet == null) {
    PresentationMaster2.setAppState(context, () => serverIP = null);
    return;
  }
  logger.v('Adding subscription');
  bool loggedInsideStreamHandler = false;
  _scanningSubscription = NetworkAnalyzer.discover2(
    subnet,
    1138,
    timeout: const Duration(seconds: 9),
  ).listen(
    (NetworkAddress addr) async {
      if (!loggedInsideStreamHandler) {
        logger.v('Assessing addresses');
        loggedInsideStreamHandler = true;
      }
      if (addr.exists) {
        logger.v('Address found: ${addr.ip}');
        if (await control(context: context, ip: addr.ip, action: ControlAction.ping) == "ok") {
          logger.i("Server found: ${addr.ip}");
          serverIP = addr.ip;
          PresentationMaster2.setAppState(context);
        }
      }
    },
    onError: (error) async {
      _resetScanningSubscription(context);
      logger.e("Lost connection (error: $error)");
      _initReconnecting(context);
    },
    onDone: () async {
      logger.v('Stream done');
      _resetScanningSubscription(context);
      while (await control(context: context, action: ControlAction.ping) == "ok" && await NetworkInfo().getWifiIP() != null) {
        await Future.delayed(const Duration(seconds: 1));
      }
      logger.e("Lost connection");
      _initReconnecting(context);
      logger.v('Started reconnecting');
    },
  );
}




Future<String> control({
  required context,
  String? ip,
  required ControlAction action,
  List<int>? mouseXY,
}) async {
  ip ??= serverIP;
  if (ip == null && _scanningSubscription == null) {
    logger.e("control() called with no ip provided in the function call and serverIP == null");
    return "no address";
  }
  if (action != ControlAction.ping && ip == null) {
    logger.e("Error: Not connected yet");
    return "error";
  }
  final mouseXYRoute = mouseXY == null ? "" : "/${mouseXY[0]}&${mouseXY[1]}";
  final route = "http://$ip:1138/${( controlRoutes[action] ?? "" ) + mouseXYRoute}";
  if (action != ControlAction.mousemove && action != ControlAction.ping) {
    logger.v("Requesting $route");
  }
  http.Response response = await http.post(Uri.parse(route)).timeout(
    Duration(seconds: action == ControlAction.mousemove ? 1 : 3),
    onTimeout: () {
      logger.e("Request timed out");
      return http.Response("timeout", 408);
    },
  );
  if (action != ControlAction.mousemove && action != ControlAction.ping) {
    logger.v(response.body);
  }
  return response.body;
}