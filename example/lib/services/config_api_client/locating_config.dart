class LocatingConfig {
  final int hitsNeeded;
  final Map<String, List<int>> locationCoordinates;
  final int timeToDieInSeconds;

  LocatingConfig(
      this.hitsNeeded, this.locationCoordinates, this.timeToDieInSeconds);

  static LocatingConfig fromJson(dynamic json) {
    return LocatingConfig(json['hitsNeeded'], json['locationCoordinates'],
        json['timeToDieInSeconds']);
  }
}
