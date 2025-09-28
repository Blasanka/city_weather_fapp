import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:forecast_weather/main.dart' show getIt;
import 'package:forecast_weather/src/data/models/city_weather_model.dart';
import 'package:forecast_weather/src/data/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityWeatherProvider extends ChangeNotifier {
  static const _kCitiesKey = 'cities_weather';
  late final WeatherService weatherService;
  final List<CityWeather> _cities = [];
  List<CityWeather> get cities => List.unmodifiable(_cities);

  CityWeatherProvider() {
    weatherService = getIt<WeatherService>();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_kCitiesKey) ?? [];
    for (final s in data) {
      try {
        final map = json.decode(s) as Map<String, dynamic>;
        _cities.add(CityWeather.fromJson(map));
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> _savePref() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _cities.map((c) => json.encode(c.toMap())).toList();
    await prefs.setStringList(_kCitiesKey, list);
  }

  Future<void> addCity(String name) async {

    final resp = await weatherService.getCurrentWeather(name);

    final location = resp['location'];
    final current = resp['current'];

    final cw = CityWeather(
      city: location['name'] as String,
      tempC: (current['temp_c'] as num).toDouble(),
      condition: (current['condition']?['text'] ?? '') as String,
      iconUrl: 'https:${current['condition']?['icon'] ?? ''}',
    );

    if (!_cities.any((c) => c.city.toLowerCase() == cw.city.toLowerCase())) {
      _cities.insert(0, cw);
      await _savePref();
      notifyListeners();
    } else {
      final idx = _cities.indexWhere((c) => c.city.toLowerCase() == cw.city.toLowerCase());
      _cities[idx] = cw;
      await _savePref();
      notifyListeners();
    }
  }

  Future<void> removeCityAt(int index) async {
    _cities.removeAt(index);
    await _savePref();
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchForecastFor(String city) => weatherService
      .getForecastedWeather(city, days: 3);
}