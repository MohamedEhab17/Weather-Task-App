import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isCelsius;
  final bool isKmph;

  const SettingsState({
    this.isCelsius = true,
    this.isKmph = true,
  });

  SettingsState copyWith({
    bool? isCelsius,
    bool? isKmph,
  }) {
    return SettingsState(
      isCelsius: isCelsius ?? this.isCelsius,
      isKmph: isKmph ?? this.isKmph,
    );
  }

  @override
  List<Object?> get props => [isCelsius, isKmph];
}
