import 'package:flutter_test/flutter_test.dart';
import 'package:forecast_weather/src/core/exceptions.dart';
import 'package:forecast_weather/src/data/models/city_weather_model.dart';
import 'package:forecast_weather/src/data/repositories/weather_repository.dart';
import 'package:forecast_weather/src/presentation/providers/city_weather_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CityWeatherProvider provider;
  late MockWeatherRepository mockWeatherRepository;
  late MockSharedPreferences mockSharedPreferences;

  final cityWeather = CityWeather(
    city: 'London',
    tempC: 15.0,
    condition: 'Sunny',
    iconUrl: 'https://cdn.weatherapi.com/weather/64x64/day/113.png',
  );

  setUp(() async {
    mockWeatherRepository = MockWeatherRepository();
    mockSharedPreferences = MockSharedPreferences();
    GetIt.I.registerSingleton<WeatherRepository>(mockWeatherRepository);
    GetIt.I.registerSingleton<SharedPreferences>(mockSharedPreferences);
    provider = CityWeatherProvider(repository: mockWeatherRepository);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  test('addCity adds a new city', () async {
    when(mockWeatherRepository.getSavedCities()).thenAnswer((_) async => []);
    when(mockWeatherRepository.getWeatherForCity('London'))
        .thenAnswer((_) async => cityWeather);
    when(mockWeatherRepository.getSavedCities()).thenAnswer((_) async => [cityWeather]);

    await provider.addCity('London');

    expect(provider.cities.length, 1);
    expect(provider.cities.first.city, 'London');
  });

  test('addCity handles WeatherApiException', () async {
    when(mockWeatherRepository.getSavedCities()).thenAnswer((_) async => []);
    when(mockWeatherRepository.getWeatherForCity('London'))
        .thenThrow(WeatherApiException('Error', 404));

    await provider.addCity('London');

    expect(provider.error.hasError, isTrue);
    expect(provider.error.message, 'Error');
  });

  test('removeCityAt removes a city', () async {
    when(mockWeatherRepository.getSavedCities()).thenAnswer((_) async => [cityWeather]);

    await Future.delayed(Duration.zero);

    await provider.removeCityAt(0);

    expect(provider.cities.isEmpty, isTrue);
  });
}