import 'package:rick_morty_flutter_app/api/domain/domain.dart';

abstract class FavoriteRepository {
  Stream<List<String>> getFavorites(String userId);
  Stream<List<Personaje>> getPersonajesFavorites(String userId);
  Future<void> addFavorite(String userId, String id);
  Future<void> removeFavorite(String userId, String id);
}
