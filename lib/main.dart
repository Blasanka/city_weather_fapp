import 'package:flutter/material.dart';
import 'package:forecast_weather/src/data/services/weather_service.dart';
import 'package:forecast_weather/src/weather_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final GetIt getIt = GetIt.instance;
void setupDependencies() {
  getIt.registerSingleton<WeatherService>(WeatherService(
      apiKey: dotenv.env['API_KEY']!,
      baseUrl: dotenv.env['BASE_URL']!,
      client: http.Client(),
    ),
  );
}

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(MyApp());
}