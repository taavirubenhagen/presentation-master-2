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




Future connect(context, {recursionIndex = 0}) async {
  logger.i("Starting network scan");
  final String? deviceIP = await NetworkInfo().getWifiIP();
  final String subnet = ( deviceIP?.substring(0, deviceIP.lastIndexOf('.')) )!;
  do {
    final stream = NetworkAnalyzer.discover2(subnet, 1138, timeout: const Duration(seconds: 5));
    stream.listen((NetworkAddress addr) async {
      if (addr.exists) {
        if (await control(context: context, ip: addr.ip, action: ControlAction.ping) == "ok") {
          logger.i("Server found");
          serverIP = addr.ip;
          MyApp.setAppState(context);
        }
      }
    });
    await Future.delayed(const Duration(seconds: 6));
  } while (deviceIP != null && serverIP == null);
  while (await control(context: context, ip: serverIP, action: ControlAction.ping) == "ok") {
    await Future.delayed(const Duration(seconds: 3));
  }
  logger.e("Lost connection");
  MyApp.setAppState(context, () => serverIP = null);
  if (recursionIndex < 16) {
    connect(context, recursionIndex: recursionIndex + 1);
  }
}




Future<String> control({
  required context,
  String? ip,
  required ControlAction action,
  List<int>? mouseXY,
}) async {
  ip ??= serverIP;
  if (action != ControlAction.ping && ip == null) {
    logger.e("Error: not connected yet");
    return "error";
  }
  final mouseXYRoute = mouseXY == null ? "" : "/${mouseXY[0]}&${mouseXY[1]}";
  final route = "http://$ip:1138/${( controlRoutes[action] ?? "" ) + mouseXYRoute}";
  if (action != ControlAction.mousemove && action != ControlAction.ping) {
    logger.v("Requesting $route");
  }
  http.Response response = await http.post(Uri.parse(route)).timeout(
    const Duration(seconds: 3),
    onTimeout: () async {
      logger.e("Request timed out");
      return http.Response("timeout", 408);
    },
  );
  if (action != ControlAction.mousemove && action != ControlAction.ping) {
    logger.v(response.body);
  }
  return response.body;
}