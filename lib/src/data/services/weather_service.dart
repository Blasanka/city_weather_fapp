import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  final String baseUrl;

  WeatherService({required this.baseUrl, required this.apiKey});

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final url = Uri.parse('$baseUrl/current.json?key=$apiKey&q=${Uri.encodeComponent(city)}&aqi=no');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed fetching weather: ${res.statusCode}');
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getForecastedWeather(String city, {int days = 3}) async {
    final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=${Uri.encodeComponent(city)}&days=$days&aqi=no&alerts=no');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed fetching forecast: ${res.statusCode}');
    }
    return json.decode(res.body) as Map<String, dynamic>;
  }
}