import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LanguageCubit extends Cubit<Locale> {
  static const String _langKey = 'selected_language';

  LanguageCubit() : super(const Locale('en'));

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_langKey);
    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, languageCode);
    emit(Locale(languageCode));
  }
}
