import 'package:flutter_beacon_example/services/config_api_client/locating_config.dart';
import 'package:flutter_beacon_example/services/config_api_client/pastebin_dio_instance.dart';

class LocatingConfigClient {
  static const String kBasePath = "";
  final _configClient = pastebinDioInstance;

  Future<LocatingConfig> getConfig() async {
    final response = await _configClient.get(kBasePath);
    final responseData = response.data;
    return LocatingConfig.fromJson(responseData);
  }
}
