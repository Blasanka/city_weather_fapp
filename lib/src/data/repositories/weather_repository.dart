
import 'dart:convert';

import 'package:forecast_weather/src/data/models/city_weather_model.dart';
import 'package:forecast_weather/src/data/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherRepository {
  static const _kCitiesKey = 'cities_weather';
  final WeatherService weatherService;
  final SharedPreferences sharedPreferences;

  WeatherRepository({required this.weatherService, required this.sharedPreferences});

  Future<List<CityWeather>> getSavedCities() async {
    final data = sharedPreferences.getStringList(_kCitiesKey) ?? [];
    return data.map((e) => CityWeather.fromJson(json.decode(e) as Map<String, dynamic>)).toList();
  }

  Future<CityWeather> getWeatherForCity(String city) async {
    final currentWeather = await weatherService.getCurrentWeather(city);
    final newCity = CityWeather.fromWeatherApi(currentWeather);
    final cities = await getSavedCities();
    if (!cities.any((c) => c.city.toLowerCase() == newCity.city.toLowerCase())) {
      cities.insert(0, newCity);
    } else {
      final idx = cities.indexWhere((c) => c.city.toLowerCase() == newCity.city.toLowerCase());
      cities[idx] = newCity;
    }
    await _saveCities(cities);
    return newCity;
  }

  Future<void> removeCity(CityWeather city) async {
    final cities = await getSavedCities();
    cities.removeWhere((c) => c.city.toLowerCase() == city.city.toLowerCase());
    await _saveCities(cities);
  }

  Future<void> _saveCities(List<CityWeather> cities) async {
    final list = cities.map((c) => json.encode(c.toMap())).toList();
    await sharedPreferences.setStringList(_kCitiesKey, list);
  }
}
