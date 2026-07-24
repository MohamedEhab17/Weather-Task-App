import 'package:injectable/injectable.dart';
import 'package:weather_task_app/features/weather_search/domain/repositories/search_repository.dart';

@lazySingleton
class GetFavoritesUseCase {
  final SearchRepository repository;

  GetFavoritesUseCase(this.repository);

  List<String> call() {
    return repository.getFavorites();
  }
}
