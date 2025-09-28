import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forecast_weather/src/data/models/city_weather_model.dart';
import 'package:forecast_weather/src/data/services/weather_service.dart';
import 'package:forecast_weather/src/presentation/providers/city_weather_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockWeatherService extends Mock implements WeatherService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CityWeatherProvider provider;
  late MockWeatherService mockWeatherService;

  final weatherResponse = {
    'location': {'name': 'London'},
    'current': {
      'temp_c': 15.0,
      'condition': {
        'text': 'Sunny',
        'icon': '//cdn.weatherapi.com/weather/64x64/day/113.png',
      },
    },
  };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    mockWeatherService = MockWeatherService();
    GetIt.I.registerSingleton<WeatherService>(mockWeatherService);

    provider = CityWeatherProvider();
  });

  tearDown(() {
    GetIt.I.reset();
  });

  test('addCity adds a new city and saves to SharedPreferences', () async {
    when(mockWeatherService.getCurrentWeather(any))
        .thenAnswer((_) async => weatherResponse);

    await provider.addCity('London');

    expect(provider.cities.length, 1);
    expect(provider.cities.first.city, 'London');

    final prefs = await SharedPreferences.getInstance();
    final savedCities = prefs.getStringList('cities');
    expect(savedCities, contains('London'));
  });

  test('addCity updates an existing city', () async {
    final initialCityWeather = CityWeather(
      city: 'London',
      tempC: 15.0,
      condition: 'Sunny',
      iconUrl: 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
    );
    SharedPreferences.setMockInitialValues({
      'cities': [json.encode(initialCityWeather.toMap())],
    });

    final updatedWeatherResponse = {
      'location': {'name': 'London'},
      'current': {
        'temp_c': 20.0,
        'condition': {
          'text': 'Cloudy',
          'icon': '//cdn.weatherapi.com/weather/64x64/day/116.png'
        }
      }
    };

    when(mockWeatherService.getCurrentWeather(any))
        .thenAnswer((_) async => updatedWeatherResponse);

    final provider = CityWeatherProvider();
    await Future.delayed(Duration.zero);

    await provider.addCity('London');

    expect(provider.cities.length, 1);
    expect(provider.cities.first.tempC, 20.0);
    expect(provider.cities.first.condition, 'Cloudy');
  });

  test('removeCityAt removes a city', () async {
    final initialCityWeather = CityWeather(
      city: 'London',
      tempC: 15.0,
      condition: 'Sunny',
      iconUrl: 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
    );

    SharedPreferences.setMockInitialValues({
      'cities': [json.encode(initialCityWeather.toMap())],
    });

    final provider = CityWeatherProvider();
    await Future.delayed(Duration.zero);

    expect(provider.cities.length, 1);
    expect(provider.cities.first.city, 'London');

    await provider.removeCityAt(0);

    expect(provider.cities.isEmpty, isTrue);

    final prefs = await SharedPreferences.getInstance();
    final savedCities = prefs.getStringList('cities') ?? [];
    expect(savedCities.isEmpty, isTrue);
  });

  test('fetchForecastFor fetches forecast', () async {
    final forecastResponse = {
      'forecast': {
        'forecastday': []
      }
    };
    when(mockWeatherService.getForecastedWeather(any, days: 3))
        .thenAnswer((_) async => forecastResponse);

    final forecast = await provider.fetchForecastFor('London');

    expect(forecast, forecastResponse);
  });
});
}
