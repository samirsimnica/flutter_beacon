import 'package:geolocator/geolocator.dart';

import 'logged_position.dart';

class LocationService {
  Future<bool> askLocationPermissions() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always) {
      return true;
    }
    final requestedPermission = await Geolocator.requestPermission();
    return requestedPermission == LocationPermission.always;
  }

  Future<LoggedPosition> getLocationData() async {
    final position = await Geolocator.getCurrentPosition();
    return LoggedPosition(position.latitude, position.longitude);
  }
}
