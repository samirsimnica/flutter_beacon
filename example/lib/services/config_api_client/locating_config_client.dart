import 'package:flutter_beacon_example/services/api_client/dio_instance.dart';
import 'package:flutter_beacon_example/services/config_api_client/locating_config.dart';

class LocatingConfigClient {
  final _configClient = dioInstance;

  Future<LocatingConfig> getConfig() async {
    final response = await _configClient.get("/beaconConfigSetup");
    final responseData = response.data;
    return LocatingConfig.fromJson(responseData);
  }
}
