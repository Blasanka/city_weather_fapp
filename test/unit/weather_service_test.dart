import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:forecast_weather/src/core/exceptions.dart';
import 'package:forecast_weather/src/data/services/weather_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('WeatherService', () {
    late WeatherService weatherService;
    late MockClient mockClient;

    test('getCurrentWeather returns weather data', () async {
      mockClient = MockClient((request) async {
        if (request.url.path.contains('current.json')) {
          return http.Response(json.encode({'location': {'name': 'London'}}), 200);
        }
        return http.Response('Not Found', 404);
      });
      weatherService = WeatherService(
        apiKey: 'test_api_key',
        baseUrl: 'https://api.weatherapi.com/v1',
        client: mockClient,
      );
      final weather = await weatherService.getCurrentWeather('London');
      expect(weather, isA<Map<String, dynamic>>());
      expect(weather['location']['name'], 'London');
    });

    test('getForecastedWeather returns forecast data', () async {
      mockClient = MockClient((request) async {
        if (request.url.path.contains('forecast.json')) {
          return http.Response(json.encode({'forecast': {}}), 200);
        }
        return http.Response('Not Found', 404);
      });
      weatherService = WeatherService(
        apiKey: 'test_api_key',
        baseUrl: 'https://api.weatherapi.com/v1',
        client: mockClient,
      );
      final forecast = await weatherService.getForecastedWeather('London');
      expect(forecast, isA<Map<String, dynamic>>());
      expect(forecast.containsKey('forecast'), isTrue);
    });

    test('throws WeatherApiException400 for code 1003', () async {
      mockClient = MockClient((request) async {
        return http.Response(json.encode({'error': {'code': 1003, 'message': 'Parameter \'q\' not provided.'}}), 400);
      });
      weatherService = WeatherService(
        apiKey: 'test_api_key',
        baseUrl: 'https://api.weatherapi.com/v1',
        client: mockClient,
      );

      expect(
        () => weatherService.getCurrentWeather('London'),
        throwsA(isA<WeatherApiException400>()),
      );
    });

    test('throws WeatherApiException401 for code 1002', () async {
      mockClient = MockClient((request) async {
        return http.Response(json.encode({'error': {'code': 1002, 'message': 'API key not provided'}}), 401);
      });
      weatherService = WeatherService(
        apiKey: 'test_api_key',
        baseUrl: 'https://api.weatherapi.com/v1',
        client: mockClient,
      );

      expect(
        () => weatherService.getCurrentWeather('London'),
        throwsA(isA<WeatherApiException401>()),
      );
    });

    test('throws WeatherApiException403 for code 2007', () async {
      mockClient = MockClient((request) async {
        return http.Response(json.encode({'error': {'code': 2007, 'message': 'API key has exceeded calls per month quota.'}}), 403);
      });
      weatherService = WeatherService(
        apiKey: 'test_api_key',
        baseUrl: 'https://api.weatherapi.com/v1',
        client: mockClient,
      );

      expect(
        () => weatherService.getCurrentWeather('London'),
        throwsA(isA<WeatherApiException403>()),
      );
    });

    test('throws generic WeatherApiException for other errors', () async {
      mockClient = MockClient((request) async {
        return http.Response(json.encode({'error': {'code': 9999, 'message': 'Unknown error'}}), 500);
      });
      weatherService = WeatherService(
        apiKey: 'test_api_key',
        baseUrl: 'https://api.weatherapi.com/v1',
        client: mockClient,
      );

      expect(
        () => weatherService.getCurrentWeather('London'),
        throwsA(isA<WeatherApiException>()),
      );
    });
  });
}
