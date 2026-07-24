import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_task_app/core/base/safe_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/domain/usecases/get_dashboard_weather_usecase.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_state.dart';

@lazySingleton
class DashboardCubit extends SafeCubit<DashboardState> {
  final GetDashboardWeatherUseCase getDashboardWeatherUseCase;
  final SharedPreferences sharedPreferences;

  static const String _favKey = 'favorite_cities';

  DashboardCubit({
    required this.getDashboardWeatherUseCase,
    required this.sharedPreferences,
  }) : super(const DashboardInitial());

  Future<void> init() async {
    final favoritesList = sharedPreferences.getStringList(_favKey) ?? ['Cairo', 'London', 'Tokyo'];
    final defaultCity = favoritesList.isNotEmpty ? favoritesList.first : 'Cairo';
    await fetchWeatherForCity(defaultCity, isInitialLoad: true);
  }

  Future<void> fetchWeatherForCity(String city, {bool isInitialLoad = false}) async {
    if (!isInitialLoad) {
      emit(const DashboardLoading());
    }

    final result = await getDashboardWeatherUseCase(city);

    result.fold(
      (failure) {
        emit(DashboardError(message: failure.message));
      },
      (weather) {
        emit(DashboardSuccess(weather: weather));
      },
    );
  }
}
