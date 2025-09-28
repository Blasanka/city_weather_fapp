class CityWeather {
  final String city;
  final double tempC;
  final String condition;
  final String iconUrl;

  CityWeather({
    required this.city,
    required this.tempC,
    required this.condition,
    required this.iconUrl,
  });

  Map<String, dynamic> toMap() => {
    'city': city,
    'tempC': tempC,
    'condition': condition,
    'iconUrl': iconUrl,
  };

  factory CityWeather.fromJson(Map<String, dynamic> j) {
    return CityWeather(
      city: j['city'],
      tempC: (j['tempC'] as num).toDouble(),
      condition: j['condition'],
      iconUrl: j['iconUrl'],
    );
  }
}
