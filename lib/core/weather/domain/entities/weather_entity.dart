class WeatherEntity {
  final String locationName;
  final String region;
  final String country;
  final String localTime;
  final double tempC;
  final double tempF;
  final bool isDay;
  final String conditionText;
  final String conditionIcon;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final int humidity;
  final int cloud;
  final double feelsLikeC;
  final double feelsLikeF;
  final double visKm;
  final double visMiles;
  final double uv;
  
  // Astro data (Sun cycle)
  final String sunrise;
  final String sunset;

  // Forecast data
  final List<ForecastDayEntity> forecastDays;
  final List<HourlyForecastEntity> hourlyForecast;

  const WeatherEntity({
    required this.locationName,
    required this.region,
    required this.country,
    required this.localTime,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.conditionText,
    required this.conditionIcon,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.humidity,
    required this.cloud,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.sunrise,
    required this.sunset,
    required this.forecastDays,
    required this.hourlyForecast,
  });
}

class ForecastDayEntity {
  final String date;
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final double avgTempC;
  final double avgTempF;
  final String conditionText;
  final String conditionIcon;

  const ForecastDayEntity({
    required this.date,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.conditionText,
    required this.conditionIcon,
  });
}

class HourlyForecastEntity {
  final String time;
  final double tempC;
  final double tempF;
  final bool isDay;
  final String conditionText;
  final String conditionIcon;

  const HourlyForecastEntity({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.conditionText,
    required this.conditionIcon,
  });
}
