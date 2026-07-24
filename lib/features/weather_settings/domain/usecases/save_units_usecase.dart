import 'package:injectable/injectable.dart';
import 'package:weather_task_app/features/weather_settings/domain/repositories/settings_repository.dart';

@lazySingleton
class SaveUnitsUseCase {
  final SettingsRepository repository;

  SaveUnitsUseCase(this.repository);

  Future<void> saveIsCelsius(bool value) async {
    await repository.saveIsCelsius(value);
  }

  Future<void> saveIsKmph(bool value) async {
    await repository.saveIsKmph(value);
  }
}
