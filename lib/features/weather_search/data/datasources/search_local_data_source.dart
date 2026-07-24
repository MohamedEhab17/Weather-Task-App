import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SearchLocalDataSource {
  List<String> getFavorites();
  Future<void> saveFavorites(List<String> favorites);
}

@LazySingleton(as: SearchLocalDataSource)
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _favKey = 'favorite_cities';

  SearchLocalDataSourceImpl(this.sharedPreferences);

  @override
  List<String> getFavorites() {
    return sharedPreferences.getStringList(_favKey) ??
        ['Cairo', 'Los Angeles', 'Salmiya', 'Moscow'];
  }

  @override
  Future<void> saveFavorites(List<String> favorites) async {
    await sharedPreferences.setStringList(_favKey, favorites);
  }
}
