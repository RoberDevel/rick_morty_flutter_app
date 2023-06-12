import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rick_morty_flutter_app/api/api.dart';

//clase que se encarga de llamar a la api de rick and morty. Extiende de
//PersonajesDatasource (de la capa dominio) porque es la clase que define como
//quiero que sean mis origenes de datos

class RickApiDatasource extends PersonajesDatasource {
  final dio = Dio(
    BaseOptions(baseUrl: 'https://rickandmortyapi.com/api'),
  );

//metodo que llama a la api y devuelve la lista de personajes
  @override
  Future<List<Personaje>> getPersonajes({int page = 1}) async {
    final response = await dio.get('/character?page=$page');
    final parsedResponse = response.data as Map<String, dynamic>;

    final result = parsedResponse['results'] as List;

    final parsedResult = List.castFrom<dynamic, Map<String, dynamic>>(result);

    return parsedResult.map(Personaje.fromJson).toList();
  }

  @override
  Future<List<Personaje>> getPersonajesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final args = ids.join(',');
    final response = await dio.get('/character/$args');

    if (response.data is List) {
      print('es una lista');
      final parsedResponse = response.data as List;
      final parsedResult = List.castFrom<dynamic, Map<String, dynamic>>(
        parsedResponse,
      );

      return parsedResult.map(Personaje.fromJson).toList();
    } else {
      final parsedResponse = Map.castFrom<dynamic, dynamic, String, dynamic>(
        response.data as Map,
      );
      print('no es una lista');
      return [Personaje.fromJson(parsedResponse)];
    }
  }

  @override
  Future<List<Personaje>> getFilteredCharacters({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await dio.get('/character?page=$page&name=$query');
      if (response.statusCode == 404) {
        return [];
      }
      final parsedResponse = response.data as Map<String, dynamic>;

      final result = parsedResponse['results'] as List;

      final parsedResult = List.castFrom<dynamic, Map<String, dynamic>>(result);

      return parsedResult.map(Personaje.fromJson).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
