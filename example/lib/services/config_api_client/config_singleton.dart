import 'package:flutter_beacon_example/services/config_api_client/locating_config.dart';

class ConfigSingleton {
  static ConfigSingleton? _instance;

  ConfigSingleton._(LocatingConfig locatingConfig);

  factory ConfigSingleton({required LocatingConfig locatingConfig}) {
    _instance ??= ConfigSingleton._(locatingConfig);
    return _instance!;
  }
}
