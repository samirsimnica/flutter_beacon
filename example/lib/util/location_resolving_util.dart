import 'package:flutter_beacon/flutter_beacon.dart';

class Tuple<K, V> {
  K firstValue;
  V secondValue;
  Tuple(this.firstValue, this.secondValue);
}

double kMinimumDistanceInMeters = 4;

Map<String, List<int>> locations = {
  "Lane 5": [116, 107, 117, 114],
  "Lane 6": [107, 118, 115]
};

Tuple<String, List<int>>? locationFound(List<Beacon> beacons, int neededHits,
    String locationName, List<int> minorValues) {
  int hits = 0;
  for (final beacon in beacons) {
    if (!minorValues.contains(beacon.minor)) continue;
    if (beacon.accuracy < kMinimumDistanceInMeters) hits++;
  }
  if (hits == neededHits) return Tuple(locationName, minorValues);
  return null;
}
