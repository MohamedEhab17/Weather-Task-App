import 'package:home_widget/home_widget.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_task_app/core/base/safe_cubit.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
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
    final favoritesList =
        sharedPreferences.getStringList(_favKey) ??
        ['Cairo', 'London', 'Tokyo'];
    final defaultCity = favoritesList.isNotEmpty
        ? favoritesList.first
        : 'Cairo';
    await fetchWeatherForCity(defaultCity, isInitialLoad: true);
  }

  Future<void> fetchWeatherForCity(
    String city, {
    bool isInitialLoad = false,
  }) async {
    if (!isInitialLoad) {
      emit(const DashboardLoading());
    }

    final result = await getDashboardWeatherUseCase(city);

    result.fold(
      (failure) {
        emit(DashboardError(message: failure.message));
      },
      (weather) {
        // Save to Home Widget
        _updateHomeWidget(weather);
        emit(DashboardSuccess(weather: weather));
      },
    );
  }

  Future<void> _updateHomeWidget(WeatherEntity weather) async {
    try {
      final isCelsius = sharedPreferences.getBool('is_celsius') ?? true;
      final temp = isCelsius
          ? '${weather.tempC.round()}°C'
          : '${weather.tempF.round()}°F';

      await HomeWidget.saveWidgetData<String>(
        'widget_city',
        weather.locationName,
      );
      await HomeWidget.saveWidgetData<String>('widget_temp', temp);
      await HomeWidget.saveWidgetData<String>(
        'widget_condition',
        weather.conditionText,
      );
      await HomeWidget.updateWidget(
        androidName: 'WeatherWidgetProvider',
        iOSName: 'WeatherWidgetProvider',
      );
    } catch (e) {
      print(e);
    }
  }
}
