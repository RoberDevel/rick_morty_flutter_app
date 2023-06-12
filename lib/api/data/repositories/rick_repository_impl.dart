import 'dart:developer';

import 'package:rick_morty_flutter_app/api/api.dart';

//este repositorio será el encargado de llamar al origen de datos o datasources

class RickRepositoryImpl extends RickRepository {
  RickRepositoryImpl(this.personajesDatasource);

  final RickApiDatasource personajesDatasource;

  @override
  Future<List<Personaje>> getAllPersonajes({int page = 1}) async =>
      await personajesDatasource.getPersonajes(page: page);

  @override
  Future<List<Personaje>> getFilteredCharacters({
    required String query,
    int page = 1,
  }) async {
    try {
      return personajesDatasource.getFilteredCharacters(
          query: query, page: page);
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
