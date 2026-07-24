import 'package:easy_localization/easy_localization.dart';

class SunCycleUtils {
  SunCycleUtils._();

  static double calculateSunProgress(String sunriseStr, String sunsetStr, String currentTimeStr) {
    try {
      final sunriseMins = timeToMinutes(sunriseStr);
      final sunsetMins = timeToMinutes(sunsetStr);

      final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(currentTimeStr);
      final currentMins = dateTime.hour * 60 + dateTime.minute;

      if (currentMins < sunriseMins) return 0.0;
      if (currentMins > sunsetMins) return 1.0;

      return (currentMins - sunriseMins) / (sunsetMins - sunriseMins);
    } catch (_) {
      return 0.5;
    }
  }

  static double calculateDaylightRemaining(String sunsetStr, String currentTimeStr) {
    try {
      final sunsetMins = timeToMinutes(sunsetStr);
      final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(currentTimeStr);
      final currentMins = dateTime.hour * 60 + dateTime.minute;

      if (currentMins >= sunsetMins) return 0.0;
      return (sunsetMins - currentMins) / 60.0;
    } catch (_) {
      return 0.0;
    }
  }

  static int timeToMinutes(String timeStr) {
    final parts = timeStr.split(' ');
    final hm = parts[0].split(':');
    int hours = int.parse(hm[0]);
    final minutes = int.parse(hm[1]);
    final ampm = parts[1].toUpperCase();

    if (ampm == 'PM' && hours < 12) {
      hours += 12;
    } else if (ampm == 'AM' && hours == 12) {
      hours = 0;
    }
    return hours * 60 + minutes;
  }
}
