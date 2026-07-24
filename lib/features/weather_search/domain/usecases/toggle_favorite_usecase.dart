import 'package:injectable/injectable.dart';
import 'package:weather_task_app/features/weather_search/domain/repositories/search_repository.dart';

@lazySingleton
class ToggleFavoriteUseCase {
  final SearchRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<List<String>> call(String city) async {
    final list = List<String>.from(repository.getFavorites());
    final cleanCity = city.trim();
    final lowerCity = cleanCity.toLowerCase();
    
    final index = list.indexWhere((element) => element.toLowerCase() == lowerCity);
    if (index != -1) {
      list.removeAt(index);
    } else {
      list.add(cleanCity);
    }
    await repository.saveFavorites(list);
    return list;
  }
}
