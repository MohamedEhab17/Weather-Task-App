import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.locationName,
    required super.region,
    required super.country,
    required super.localTime,
    required super.tempC,
    required super.tempF,
    required super.isDay,
    required super.conditionText,
    required super.conditionIcon,
    required super.windMph,
    required super.windKph,
    required super.windDegree,
    required super.windDir,
    required super.pressureMb,
    required super.humidity,
    required super.cloud,
    required super.feelsLikeC,
    required super.feelsLikeF,
    required super.visKm,
    required super.visMiles,
    required super.uv,
    required super.sunrise,
    required super.sunset,
    required super.forecastDays,
    required super.hourlyForecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final forecast = json['forecast'] as Map<String, dynamic>? ?? {};
    final forecastDaysList = forecast['forecastday'] as List<dynamic>? ?? [];

    // Parse forecast days
    final forecastDays = forecastDaysList.map((dayJson) {
      final date = dayJson['date'] as String? ?? '';
      final day = dayJson['day'] as Map<String, dynamic>? ?? {};
      final condition = day['condition'] as Map<String, dynamic>? ?? {};

      return ForecastDayEntity(
        date: date,
        maxTempC: (day['maxtemp_c'] as num?)?.toDouble() ?? 0.0,
        maxTempF: (day['maxtemp_f'] as num?)?.toDouble() ?? 0.0,
        minTempC: (day['mintemp_c'] as num?)?.toDouble() ?? 0.0,
        minTempF: (day['mintemp_f'] as num?)?.toDouble() ?? 0.0,
        avgTempC: (day['avgtemp_c'] as num?)?.toDouble() ?? 0.0,
        avgTempF: (day['avgtemp_f'] as num?)?.toDouble() ?? 0.0,
        conditionText: condition['text'] as String? ?? '',
        conditionIcon: condition['icon'] as String? ?? '',
      );
    }).toList();

    // Parse hourly forecast for today (first day in forecastday)
    List<HourlyForecastEntity> hourlyForecast = [];
    String sunrise = '';
    String sunset = '';

    if (forecastDaysList.isNotEmpty) {
      final firstDayJson = forecastDaysList.first as Map<String, dynamic>;
      final astro = firstDayJson['astro'] as Map<String, dynamic>? ?? {};
      sunrise = astro['sunrise'] as String? ?? '';
      sunset = astro['sunset'] as String? ?? '';

      final hourList = firstDayJson['hour'] as List<dynamic>? ?? [];
      hourlyForecast = hourList.map((hourJson) {
        final time = hourJson['time'] as String? ?? '';
        final condition = hourJson['condition'] as Map<String, dynamic>? ?? {};

        return HourlyForecastEntity(
          time: time,
          tempC: (hourJson['temp_c'] as num?)?.toDouble() ?? 0.0,
          tempF: (hourJson['temp_f'] as num?)?.toDouble() ?? 0.0,
          isDay: (hourJson['is_day'] as num?)?.toInt() == 1,
          conditionText: condition['text'] as String? ?? '',
          conditionIcon: condition['icon'] as String? ?? '',
        );
      }).toList();
    }

    final currentCondition = current['condition'] as Map<String, dynamic>? ?? {};

    return WeatherModel(
      locationName: location['name'] as String? ?? '',
      region: location['region'] as String? ?? '',
      country: location['country'] as String? ?? '',
      localTime: location['localtime'] as String? ?? '',
      tempC: (current['temp_c'] as num?)?.toDouble() ?? 0.0,
      tempF: (current['temp_f'] as num?)?.toDouble() ?? 0.0,
      isDay: (current['is_day'] as num?)?.toInt() == 1,
      conditionText: currentCondition['text'] as String? ?? '',
      conditionIcon: currentCondition['icon'] as String? ?? '',
      windMph: (current['wind_mph'] as num?)?.toDouble() ?? 0.0,
      windKph: (current['wind_kph'] as num?)?.toDouble() ?? 0.0,
      windDegree: (current['wind_degree'] as num?)?.toInt() ?? 0,
      windDir: current['wind_dir'] as String? ?? '',
      pressureMb: (current['pressure_mb'] as num?)?.toDouble() ?? 0.0,
      humidity: (current['humidity'] as num?)?.toInt() ?? 0,
      cloud: (current['cloud'] as num?)?.toInt() ?? 0,
      feelsLikeC: (current['feelslike_c'] as num?)?.toDouble() ?? 0.0,
      feelsLikeF: (current['feelslike_f'] as num?)?.toDouble() ?? 0.0,
      visKm: (current['vis_km'] as num?)?.toDouble() ?? 0.0,
      visMiles: (current['vis_miles'] as num?)?.toDouble() ?? 0.0,
      uv: (current['uv'] as num?)?.toDouble() ?? 0.0,
      sunrise: sunrise,
      sunset: sunset,
      forecastDays: forecastDays,
      hourlyForecast: hourlyForecast,
    );
  }
}
