import 'package:flutter/material.dart';
import 'package:forecast_weather/src/data/services/weather_service.dart';
import 'package:forecast_weather/src/weather_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:forecast_weather/src/data/repositories/weather_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;
Future<void> setupDependencies() async {
  getIt.registerSingleton<WeatherService>(WeatherService(
      apiKey: dotenv.env['API_KEY']!,
      baseUrl: dotenv.env['BASE_URL']!,
      client: http.Client(),
    ),
  );
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<WeatherRepository>(WeatherRepository(weatherService: getIt<WeatherService>(), sharedPreferences: getIt<SharedPreferences>()));
}

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(MyApp());
}