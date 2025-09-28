import 'package:flutter/material.dart';
import 'package:forecast_weather/src/presentation/providers/city_weather_provider.dart';
import 'package:forecast_weather/src/presentation/widgets/city_card_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CityWeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather - Cities'),
        actions: [
          IconButton(
            onPressed: () => _openAddDialog(context),
            icon: const Icon(Icons.add),
            tooltip: 'Add city',
          ),
        ],
      ),
      body: store.cities.isEmpty
          ? Center(
              child: Text(
                'No cities yet. Tap + to add.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                // refresh all cities
                for (final c in store.cities) {
                  try {
                    await store.addCity(c.city);
                  } catch (_) {}
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: store.cities.length,
                itemBuilder: (ctx, i) {
                  final c = store.cities[i];
                  return Dismissible(
                    key: ValueKey(c.city),
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerLeft,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => store.removeCityAt(i),
                    child: CityCardWidget(cityWeather: c, index: i),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => Dialog());
  }
}
