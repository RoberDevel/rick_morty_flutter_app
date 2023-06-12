import 'package:rick_morty_flutter_app/api/api.dart';

//Clase para mapear los datos de la API a la entidad que usará la aplicación

class PersonajeMapper {
  static Personaje rickToEntity(RickApiResults personajeRickApi) => Personaje(
        id: personajeRickApi.id,
        name: personajeRickApi.name,
        status: personajeRickApi.status,
        image: personajeRickApi.image,
        origin: personajeRickApi.origin as PersonajeOrigin,
        location: personajeRickApi.location as PersonajeLocation,
      );
}
