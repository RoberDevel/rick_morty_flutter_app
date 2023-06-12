import 'package:rick_morty_flutter_app/api/api.dart';

//Clase que define como lucen los origenes de datos, como traer una lista de
//personajes, o filtrados, etc.
//Está en la carpeta domain porque es la capa de dominio la que define como
//quiero que sean mis origenes de datos, pero se implementa en
//la capa de data (por RickApiDatasource) porque es la capa de data la que realiza
//la implementación de los origenes de datos

abstract class PersonajesDatasource {
  Future<List<Personaje>> getPersonajes({int page = 1});
  Future<void> getFilteredCharacters({
    required String query,
    int page = 1,
  });
  Future<List<Personaje>> getPersonajesByIds(List<String> ids);
}
