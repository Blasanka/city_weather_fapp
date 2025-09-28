import 'package:flutter/foundation.dart';
import 'package:forecast_weather/src/data/models/city_weather_model.dart';
import 'package:forecast_weather/src/data/repositories/weather_repository.dart';

import 'package:forecast_weather/src/core/exceptions.dart';
import 'package:forecast_weather/src/presentation/providers/error.dart';

class CityWeatherProvider extends ChangeNotifier {
  late final WeatherRepository weatherRepository;
  final List<CityWeather> _cities = [];
  List<CityWeather> get cities => List.unmodifiable(_cities);
  AppError _error = AppError(message: '');
  AppError get error => _error;

  CityWeatherProvider({required WeatherRepository repository}) {
    weatherRepository = repository;
    _loadCities();
  }

  Future<void> _loadCities() async {
    final cities = await weatherRepository.getSavedCities();
    _cities.clear();
    _cities.addAll(cities);
    notifyListeners();
  }

  Future<void> addCity(String name) async {
    try {
      await weatherRepository.getWeatherForCity(name);
      await _loadCities();
    } on WeatherApiException catch (e) {
      _error = AppError(message: e.message, hasError: true);
      notifyListeners();
    }
  }

  void clearError() {
    _error = AppError(message: '');
  }

  Future<void> removeCityAt(int index) async {
    final city = _cities[index];
    await weatherRepository.removeCity(city);
    _cities.removeAt(index);
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchForecastFor(String city) {
    return weatherRepository.weatherService
      .getForecastedWeather(city, days: 3);
  }
}