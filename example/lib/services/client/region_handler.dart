import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

class RegionHandler extends ChangeNotifier {
  static final RegionHandler _RegionHandler = RegionHandler._internal();

  List<Region> _regions = [];

  factory RegionHandler() {
    return _RegionHandler;
  }

  RegionHandler._internal();

  List<Region> get regions => _regions;

  void addRegion(Region region) {
    this._regions.add(region);
    notifyListeners();
  }

  void removeRegion(Region region) {
    for (final currentRegion in this._regions) {
      if (currentRegion.identifier == region.identifier) {
        this._regions.remove(currentRegion);
        notifyListeners();
        break;
      }
    }
  }
}
