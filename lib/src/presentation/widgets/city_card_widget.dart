import 'package:flutter/material.dart';
import 'package:forecast_weather/src/data/models/city_weather_model.dart';
import 'package:forecast_weather/src/presentation/providers/city_weather_provider.dart';
import 'package:forecast_weather/src/presentation/screens/forecast_screen.dart';
import 'package:provider/provider.dart';

class CityCardWidget extends StatelessWidget {
  final CityWeather cityWeather;
  final int index;

  const CityCardWidget({
    required this.cityWeather,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CityWeatherProvider>();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _openForecast(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.network(
                cityWeather.iconUrl,
                width: 56,
                height: 56,
                errorBuilder: (_, __, ___) => const Icon(Icons.cloud, size: 56),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityWeather.city,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${cityWeather.tempC.toStringAsFixed(1)}°C • ${cityWeather.condition}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openForecast(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ForecastScreen(city: cityWeather.city),
    ));
  }
}
