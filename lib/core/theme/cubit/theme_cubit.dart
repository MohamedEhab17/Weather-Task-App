import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark }

class ThemeCubit extends Cubit<AppThemeMode> {
  static const String _themeKey = 'selected_theme';

  ThemeCubit() : super(AppThemeMode.light);

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeName = prefs.getString(_themeKey);
    if (themeName != null) {
      final themeMode = AppThemeMode.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => AppThemeMode.light,
      );
      emit(themeMode);
    }
  }

  Future<void> changeTheme(AppThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode.name);
    emit(themeMode);
  }

  Future<void> toggleTheme() async {
    final newTheme = state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    await changeTheme(newTheme);
  }
}
