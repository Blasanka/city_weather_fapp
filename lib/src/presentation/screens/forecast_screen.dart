import 'package:flutter/material.dart';
import 'package:forecast_weather/src/presentation/providers/city_weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ForecastScreen extends StatelessWidget {
  final String city;

  const ForecastScreen({required this.city, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CityWeatherProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('$city forecast')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: provider.fetchForecastFor(city),
        builder: (ctx, snap) {

          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text('Failed to load forecast'));
          }

          final data = snap.data!;
          final forecastDays =
              (data['forecast']?['forecastday'] as List<dynamic>?) ?? [];

          return PageView.builder(
            itemCount: forecastDays.length,
            itemBuilder: (ctx, i) {
              final day = forecastDays[i];
              final date = DateTime.parse(day['date']);
              final c = day['day'];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      DateFormat.yMMMMEEEEd().format(date),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Image.network(
                      'https:${c['condition']['icon']}',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${c['avgtemp_c'].toString()} °C',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${c['condition']['text']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
