import 'package:dio/dio.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_example/services/client/dio_instance.dart';

class ApiClient {
  Dio _client = dioInstance;

  Future<void> sendScanResults(RangingResult result) async {
    final serializedResult = result.toJson;
    serializedResult['latency'] = DateTime.now().millisecondsSinceEpoch;
    await _client.post("/logRegionScan", data: serializedResult);
  }
}
