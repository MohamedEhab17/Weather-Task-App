import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  bool getIsCelsius();
  Future<void> saveIsCelsius(bool value);
  bool getIsKmph();
  Future<void> saveIsKmph(bool value);
}

@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _celsiusKey = 'is_celsius';
  static const String _kmphKey = 'is_kmph';

  SettingsLocalDataSourceImpl(this.sharedPreferences);

  @override
  bool getIsCelsius() {
    return sharedPreferences.getBool(_celsiusKey) ?? true;
  }

  @override
  Future<void> saveIsCelsius(bool value) async {
    await sharedPreferences.setBool(_celsiusKey, value);
  }

  @override
  bool getIsKmph() {
    return sharedPreferences.getBool(_kmphKey) ?? true;
  }

  @override
  Future<void> saveIsKmph(bool value) async {
    await sharedPreferences.setBool(_kmphKey, value);
  }
}
