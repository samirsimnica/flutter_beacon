import 'package:wifi_scan/wifi_scan.dart';

import 'wifi_access_point.dart';

class WifiScanningService {
  final _scanningInstance = WiFiScan.instance;

  Future<List<WifiAccessPoint>> getCurrentlyScannedWifiRouters() async {
    final scanningResult = await _scanningInstance.getScannedResults();
    if (scanningResult.hasError) return [];

    return scanningResult.value!
        .map((e) => new WifiAccessPoint(e.ssid, e.level, e.frequency))
        .toList();
  }
}
