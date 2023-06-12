part of 'personaje_rick_api.dart';

//Clase con el objeto results, que es lo que se usará.

class RickApiResponse {
  final Info info;
  final List<RickApiResults> results;

  RickApiResponse({
    required this.info,
    required this.results,
  });

  factory RickApiResponse.fromJson(Map<String, dynamic> json) =>
      RickApiResponse(
        info: Info.fromJson(json["info"] as Map<String, dynamic>),
        results: List<RickApiResults>.from(
          (json["results"] as List<Map<String, dynamic>>)
              .map(RickApiResults.fromJson),
        ),
      );

  Map<String, dynamic> toJson() => {
        "info": info.toJson(),
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Info {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  Info({
    required this.count,
    required this.pages,
    required this.next,
    this.prev,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        count: json["count"] as int,
        pages: json["pages"] as int,
        next: json["next"] as String,
        prev: json["prev"] as String,
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "pages": pages,
        "next": next,
        "prev": prev,
      };
}
