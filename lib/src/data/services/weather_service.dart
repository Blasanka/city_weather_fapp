import 'package:forecast_weather/src/core/exceptions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  final String baseUrl;

  http.Client client;

  WeatherService({
    required this.baseUrl,
    required this.apiKey,
    required this.client,
  });

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final url = Uri.parse(
      '$baseUrl/current.json?key=$apiKey&q=${Uri.encodeComponent(city)}&aqi=no',
    );

    final res = await client.get(url);

    if (res.statusCode != 200) {
      final errorBody = json.decode(res.body) as Map<String, dynamic>;
      final error = errorBody['error'] as Map<String, dynamic>;
      final code = error['code'] as int;
      final message = error['message'] as String;

      switch (code) {
        case 1003:
          throw WeatherApiException400(message, code);
        case 1002:
          throw WeatherApiException401(message, code);
        case 2007:
          throw WeatherApiException403(message, code);
        default:
          throw WeatherApiException(message, code);
      }
    }

    return json.decode(res.body);
  }

  Future<Map<String, dynamic>> getForecastedWeather(
    String city, {
    int days = 3,
  }) async {

    final url = Uri.parse(
      '$baseUrl/forecast.json?key=$apiKey&q=${Uri.encodeComponent(city)}&days=$days&aqi=no&alerts=no',
    );

    final res = await client.get(url);

    if (res.statusCode != 200) {
      final errorBody = json.decode(res.body) as Map<String, dynamic>;
      final error = errorBody['error'] as Map<String, dynamic>;
      final code = error['code'] as int;
      final message = error['message'] as String;

      switch (code) {
        case 1003:
          throw WeatherApiException400(message, code);
        case 1002:
          throw WeatherApiException401(message, code);
        case 2007:
          throw WeatherApiException403(message, code);
        default:
          throw WeatherApiException(message, code);
      }
    }

    return json.decode(res.body);
  }
}
