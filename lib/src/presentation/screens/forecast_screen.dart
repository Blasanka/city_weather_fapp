import 'package:flutter/material.dart';
import 'package:forecast_weather/src/presentation/providers/city_weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ForecastScreen extends StatefulWidget {
  final String city;

  const ForecastScreen({required this.city, super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CityWeatherProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('${widget.city} forecast')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: provider.fetchForecastFor(widget.city),
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
                  controller: _controller,
                  itemCount: forecastDays.length,
                  itemBuilder: (ctx, i) {
                    final day = forecastDays[i];
                    final date = DateTime.parse(day['date']);
                    final c = day['day'];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF1D2671), Color(0xFF3A3A98)],
                        )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          const SizedBox(height: 12),
          SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: const WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              spacing: 8,
              activeDotColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
