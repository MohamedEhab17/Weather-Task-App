import 'package:injectable/injectable.dart';
import 'package:weather_task_app/core/base/safe_cubit.dart';
import 'package:weather_task_app/features/weather_settings/domain/usecases/get_units_usecase.dart';
import 'package:weather_task_app/features/weather_settings/domain/usecases/save_units_usecase.dart';
import 'package:weather_task_app/core/settings/cubit/settings_state.dart';

@lazySingleton
class SettingsCubit extends SafeCubit<SettingsState> {
  final GetUnitsUseCase getUnitsUseCase;
  final SaveUnitsUseCase saveUnitsUseCase;

  SettingsCubit({
    required this.getUnitsUseCase,
    required this.saveUnitsUseCase,
  }) : super(const SettingsState());

  void init() {
    final prefs = getUnitsUseCase();
    emit(SettingsState(
      isCelsius: prefs.isCelsius,
      isKmph: prefs.isKmph,
    ));
  }

  Future<void> toggleTempUnit() async {
    final newValue = !state.isCelsius;
    await saveUnitsUseCase.saveIsCelsius(newValue);
    emit(state.copyWith(isCelsius: newValue));
  }

  Future<void> toggleWindUnit() async {
    final newValue = !state.isKmph;
    await saveUnitsUseCase.saveIsKmph(newValue);
    emit(state.copyWith(isKmph: newValue));
  }
}
