import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_example/services/api_client/dio_instance.dart';

import '../geo_location/logged_position.dart';
import '../wifi_adapter/wifi_access_point.dart';

class LoggingModel {
  final LoggedPosition _currentPosition;
  final List<WifiAccessPoint> _accessPoints;
  final List<Beacon> _beacons;

  LoggingModel(this._currentPosition, this._accessPoints, this._beacons);
  Map<String, dynamic> toJson() => {
        'currentPosition': _currentPosition,
        'accessPoints': _accessPoints,
        'beaconMap': _beacons.map((e) => e.toJson).toList()
      };
}

class LoggingApiClient {
  Dio _client = dioInstance;

  Future<void> sendScanResults(LoggingModel result) async {
    final serializedResult = result.toJson();
    serializedResult['latency'] = DateTime.now().millisecondsSinceEpoch;
    await _client.post("/logRegionScan", data: serializedResult);
  }
}
