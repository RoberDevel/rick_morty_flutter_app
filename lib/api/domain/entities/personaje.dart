// Esta es la entidad que usará la aplicacion para mostrar los datos de los personajes

class Personaje {
  Personaje({
    required this.id,
    required this.name,
    required this.status,
    // required this.species,
    // required this.type,
    // required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    // required this.episode,
    // required this.url,
    // required this.created,
  });

  final int id;
  final String name;
  final String status;
  // final String species;
  // final String type;
  // final String gender;
  final PersonajeOrigin origin;
  final PersonajeLocation location;
  final String image;
  // final List<String> episode;
  // final String url;
  // final String created;

  factory Personaje.fromJson(Map<String, dynamic> json) => Personaje(
        id: json['id'] as int,
        name: json['name'] as String,
        status: json['status'] as String,
        // species: json['species'] as String,
        //  type: json["type"] as String,
        //  gender: json["gender"] as String,
        origin:
            PersonajeOrigin.fromJson(json["origin"] as Map<String, dynamic>),
        location: PersonajeLocation.fromJson(
            json["location"] as Map<String, dynamic>),
        image: json['image'] as String,
        // episode:
        //     List<String>.from(json["episode"].map((x) => x) as List<String>),
        // url: json["url"] as String,
        // created: json["created"] as String,
      );
}

class PersonajeLocation {
  PersonajeLocation({
    required this.name,
    required this.url,
  });

  factory PersonajeLocation.fromJson(Map<String, dynamic> json) =>
      PersonajeLocation(
        name: json['name'] as String,
        url: json['url'] as String,
      );

  final String name;
  final String url;
}

class PersonajeOrigin {
  PersonajeOrigin({
    required this.name,
    required this.url,
  });

  factory PersonajeOrigin.fromJson(Map<String, dynamic> json) =>
      PersonajeOrigin(
        name: json['name'] as String,
        url: json['url'] as String,
      );

  final String name;
  final String url;
}
