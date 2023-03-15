class LoggedPosition {
   final double _latitude;

  final double _longitude;


  LoggedPosition(this._latitude, this._longitude);

   Map<String, dynamic> toJson() => {
        'latitude': _latitude,
        'longitude': _longitude,
      };
}