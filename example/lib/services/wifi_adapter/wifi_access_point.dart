class WifiAccessPoint{
  String _name;
  int _strength;
  int _frequency;

  WifiAccessPoint(this._name, this._strength,this._frequency);
  
Map<String, dynamic> toJson() => {
       'name':_name,
       'strength':_strength,
       'frequency':_frequency
      };
}