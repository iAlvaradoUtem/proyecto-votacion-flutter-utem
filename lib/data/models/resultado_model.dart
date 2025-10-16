// Estructura del conteo de votos por opcion
class Conteo {
  final String choice;
  final int total;

  Conteo({required this.choice, required this.total});

  // Crear un objeto 'Conteo' a partir de un json
  factory Conteo.fromJson(Map<String, dynamic> json) {
    return Conteo(
      choice: json['choice'],
      total: json['total'],
    );
  }
}

// Estructura completa de los resultados de una encuesta
class Resultado {
  final String name;
  final List<Conteo> results;

  Resultado({required this.name, required this.results});

  // Crear un objeto Resultado a partir de un json de la api
  factory Resultado.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List;
    List<Conteo> results = resultsList.map((i) => Conteo.fromJson(i)).toList();

    return Resultado(
      name: json['name'],
      results: results,
    );
  }
}