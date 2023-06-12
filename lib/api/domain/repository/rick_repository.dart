import 'package:rick_morty_flutter_app/api/api.dart';

//clase que define como quiero que sean mis repositorios. esta clase será
// implementada por RickRepositoryImpl
//el repositorio permite elegir que origen de datos usar

abstract class RickRepository {
  Future<List<Personaje>> getAllPersonajes({int page = 1});

  Future<List<Personaje>> getFilteredCharacters({
    required String query,
    int page = 1,
  });
}
