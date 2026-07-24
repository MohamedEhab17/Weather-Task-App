import 'package:equatable/equatable.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardSuccess extends DashboardState {
  final WeatherEntity weather;

  const DashboardSuccess({required this.weather});

  @override
  List<Object?> get props => [weather];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
