import 'package:injectable/injectable.dart';
import 'package:weather_task_app/features/weather_settings/domain/repositories/settings_repository.dart';

class UnitsPreferences {
  final bool isCelsius;
  final bool isKmph;
  UnitsPreferences({required this.isCelsius, required this.isKmph});
}

@lazySingleton
class GetUnitsUseCase {
  final SettingsRepository repository;

  GetUnitsUseCase(this.repository);

  UnitsPreferences call() {
    return UnitsPreferences(
      isCelsius: repository.getIsCelsius(),
      isKmph: repository.getIsKmph(),
    );
  }
}
