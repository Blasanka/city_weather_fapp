import 'package:flutter_test/flutter_test.dart';
import 'package:forecast_weather/src/data/models/city_weather_model.dart';

void main() {
  group('CityWeather', () {
    test('can be instantiated', () {
      final weather = CityWeather(
        city: 'London',
        tempC: 15.0,
        condition: 'Sunny',
        iconUrl: 'http://example.com/icon.png',
      );
      expect(weather, isA<CityWeather>());
    });

    test('supports value comparisons', () {
      final weather1 = CityWeather(
        city: 'London',
        tempC: 15.0,
        condition: 'Sunny',
        iconUrl: 'http://example.com/icon.png',
      );
      final weather2 = CityWeather(
        city: 'London',
        tempC: 15.0,
        condition: 'Sunny',
        iconUrl: 'http://example.com/icon.png',
      );
      expect(weather1.city, weather2.city);
    });

    test('toMap returns correct map', () {
      final weather = CityWeather(
        city: 'London',
        tempC: 15.0,
        condition: 'Sunny',
        iconUrl: 'http://example.com/icon.png',
      );
      final map = weather.toMap();
      expect(map['city'], 'London');
      expect(map['tempC'], 15.0);
      expect(map['condition'], 'Sunny');
      expect(map['iconUrl'], 'http://example.com/icon.png');
    });

    test('fromJson returns correct object', () {
      final map = {
        'city': 'London',
        'tempC': 15.0,
        'condition': 'Sunny',
        'iconUrl': 'http://example.com/icon.png',
      };
      final weather = CityWeather.fromJson(map);
      expect(weather.city, 'London');
      expect(weather.tempC, 15.0);
      expect(weather.condition, 'Sunny');
      expect(weather.iconUrl, 'http://example.com/icon.png');
    });
  });
}
