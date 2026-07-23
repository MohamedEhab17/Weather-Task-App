class Api {
  static const String baseUrl = 'https://api.weatherapi.com/v1/';
  static const String apiKey = String.fromEnvironment('API_KEY', defaultValue: '');

  // Endpoints
  static const String current = 'current.json';
  static const String forecast = 'forecast.json';
}
