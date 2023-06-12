import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rick_morty_flutter_app/api/data/datasources/rick_api_datasource.dart';
import 'package:rick_morty_flutter_app/api/domain/entities/personaje.dart';
import 'package:rick_morty_flutter_app/favorites/favorites.dart';

class FirebaseFavoriteRepository implements FavoriteRepository {
  FirebaseFavoriteRepository({
    required RickApiDatasource apiDatasource,
  }) : _apiDatasource = apiDatasource;

  final RickApiDatasource _apiDatasource;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  @override
  Future<void> addFavorite(String userId, String id) async {
    await _store.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayUnion([id]),
    });
  }

  @override
  Stream<List<String>> getFavorites(String userId) {
    return _store.collection('users').doc(userId).snapshots().map((userDoc) {
      final favorites = userDoc.data()!['favorites'] as List;
      return favorites.map((e) => e.toString()).toList();
    });
  }

  @override
  Future<void> removeFavorite(String userId, String id) async {
    await _store.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayRemove([id]),
    });
  }

  @override
  Stream<List<Personaje>> getPersonajesFavorites(String userId) {
    return _store
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
      final favorites = userDoc.data()!['favorites'] as List;

      final ids = favorites.map((e) => e.toString()).toList();

      return _apiDatasource.getPersonajesByIds(ids);
    });
  }
}
