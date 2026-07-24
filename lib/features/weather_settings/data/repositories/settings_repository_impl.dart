import 'package:injectable/injectable.dart';
import 'package:weather_task_app/features/weather_settings/data/datasources/settings_local_data_source.dart';
import 'package:weather_task_app/features/weather_settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  bool getIsCelsius() {
    return localDataSource.getIsCelsius();
  }

  @override
  Future<void> saveIsCelsius(bool value) async {
    await localDataSource.saveIsCelsius(value);
  }

  @override
  bool getIsKmph() {
    return localDataSource.getIsKmph();
  }

  @override
  Future<void> saveIsKmph(bool value) async {
    await localDataSource.saveIsKmph(value);
  }
}
