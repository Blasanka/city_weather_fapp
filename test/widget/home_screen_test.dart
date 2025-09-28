import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forecast_weather/src/data/models/city_weather_model.dart';
import 'package:forecast_weather/src/data/repositories/weather_repository.dart';
import 'package:forecast_weather/src/presentation/providers/city_weather_provider.dart';
import 'package:forecast_weather/src/presentation/screens/home_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late CityWeatherProvider cityWeatherProvider;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    GetIt.I.reset();
    GetIt.I.registerSingleton<WeatherRepository>(mockWeatherRepository);
    cityWeatherProvider = CityWeatherProvider(repository: mockWeatherRepository);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  testWidgets('HomeScreen displays "No cities added yet" when cities list is empty', (WidgetTester tester) async {
    when(mockWeatherRepository.getSavedCities()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: cityWeatherProvider,
        child: MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No cities added yet'), findsOneWidget);
  });

  testWidgets('HomeScreen displays a list of cities when cities list is not empty', (WidgetTester tester) async {
    final cities = [
      CityWeather(city: 'London', tempC: 15.0, condition: 'Sunny', iconUrl: ''),
    ];
    when(mockWeatherRepository.getSavedCities()).thenAnswer((_) async => cities);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: cityWeatherProvider,
        child: MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('London'), findsOneWidget);
  });

  testWidgets('HomeScreen displays a add action button', (WidgetTester tester) async {
    when(mockWeatherRepository.getSavedCities()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: cityWeatherProvider,
        child: MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text("Current Weather"), findsOne);
  });
}