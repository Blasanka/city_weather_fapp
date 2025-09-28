import 'package:flutter/material.dart';
import 'package:forecast_weather/main.dart' show getIt;
import 'package:forecast_weather/src/data/services/weather_service.dart';
import 'package:forecast_weather/src/presentation/providers/city_weather_provider.dart';
import 'package:forecast_weather/src/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CityWeatherProvider>(
          create: (ctx) => CityWeatherProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Weather Forecast',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}