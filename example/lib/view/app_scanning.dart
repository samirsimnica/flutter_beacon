import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_beacon_example/controller/requirement_state_controller.dart';
import 'package:flutter_beacon_example/services/api_client/logging_api_client.dart';
import 'package:flutter_beacon_example/services/geo_location/location_service.dart';
import 'package:flutter_beacon_example/services/notifications/notification_service.dart';
import 'package:flutter_beacon_example/services/wifi_adapter/wifi_scanning_service.dart';
import 'package:flutter_beacon_example/util/location_resolving_util.dart';

import 'package:get/get.dart';

import '../services/region_handler.dart';

class TabScanning extends StatefulWidget {
  @override
  _TabScanningState createState() => _TabScanningState();
}

class _TabScanningState extends State<TabScanning> {
  StreamSubscription<RangingResult>? _streamRanging;
  LoggingApiClient _apiClient = LoggingApiClient();
  final Region _kPredefinedRegion = Region(
      proximityUUID: '17fb0cdd-fbd1-4911-b3bc-e6b1583a073f',
      identifier: 'Jonas');
  bool _hitPlace = false;
  final _locationService = LocationService();
  final _wifiService = WifiScanningService();
  final _notificationService = NotificationService();

  List<Beacon> _beacons = [];
  final _regionHandler = RegionHandler();
  final controller = Get.find<RequirementStateController>();

  @override
  void initState() {
    super.initState();
    checkForInitializations();
    _regionHandler.addListener(() {
      checkForInitializations();
    });
  }

  checkForInitializations() {
    controller.startStream.listen((flag) {
      if (flag == true) {
        initScanBeacon();
      }
    });

    controller.pauseStream.listen((flag) {
      if (flag == true) {
        pauseScanBeacon();
      }
    });
  }

  initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    if (!controller.authorizationStatusOk ||
        !controller.locationServiceEnabled ||
        !controller.bluetoothEnabled) {
      print(
          'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk},'
          'locationServiceEnabled=${controller.locationServiceEnabled},'
          'bluetoothEnabled=${controller.bluetoothEnabled}');
      return;
    }

    if (_streamRanging != null) {
      await _streamRanging?.cancel();
    }
    _streamRanging = flutterBeacon
        .ranging([_kPredefinedRegion, ..._regionHandler.regions]).listen(
            (RangingResult result) async {
      if (mounted) {
        setState(() {
          result.beacons.forEach((e) {
            final index = _beacons.indexOf(e);
            // found
            if (index != -1) {
              _beacons[index] = e;
            } else {
              _beacons.add(e);
            }
          });
        });
        final lastAcceptableTime =
            DateTime.now().subtract(Duration(seconds: 10));
        _beacons = _beacons
            .where((e) => e.lastScan.isAfter(lastAcceptableTime))
            .toList();

        for (final key in locations.keys) {
          final result = locationFound(_beacons, 4, key, locations[key]!);
          if (result != null && !_hitPlace) {
            _notificationService.setNotification(
                context,
                "Hit place ${result.firstValue}",
                "Hit beacons ${result.secondValue.join(",")}");
            _hitPlace = true;
            break;
          }
        }
        _beacons.sort(_compareParameters);

        //await _sendScanResults();
      }
    });
  }

  _sendScanResults() async {
    final locationData = await _locationService.getLocationData();
    final wifiData = await _wifiService.getCurrentlyScannedWifiRouters();
    await _apiClient
        .sendScanResults(LoggingModel(locationData, wifiData, _beacons));
  }

  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      setState(() {
        _beacons.clear();
      });
    }
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _beacons.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: _beacons.map(
                  (beacon) {
                    return ListTile(
                      title: Text(
                        beacon.proximityUUID,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      onTap: () {
                        _hitPlace = false;
                      },
                      subtitle: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              'Major: ${beacon.major}\nMinor: ${beacon.minor}',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            flex: 1,
                            fit: FlexFit.tight,
                          ),
                          Flexible(
                            child: Text(
                              'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            flex: 2,
                            fit: FlexFit.tight,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ).toList(),
            ),
    );
  }
}
