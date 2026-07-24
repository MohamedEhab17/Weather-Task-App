abstract class SettingsRepository {
  bool getIsCelsius();
  Future<void> saveIsCelsius(bool value);
  bool getIsKmph();
  Future<void> saveIsKmph(bool value);
}
