class WeatherApiException implements Exception {
  final String message;
  final int code;

  WeatherApiException(this.message, this.code);

  @override
  String toString() => 'WeatherApiException: [' + code.toString() + '] ' + message;
}

class WeatherApiException400 extends WeatherApiException {
  WeatherApiException400(String message, int code) : super(message, code);
}

class WeatherApiException401 extends WeatherApiException {
  WeatherApiException401(String message, int code) : super(message, code);
}

class WeatherApiException403 extends WeatherApiException {
  WeatherApiException403(String message, int code) : super(message, code);
}
