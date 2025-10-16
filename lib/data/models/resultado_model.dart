class Conteo {
  final String choice;
  final int total;

  Conteo({required this.choice, required this.total});

  factory Conteo.fromJson(Map<String, dynamic> json) {
    return Conteo(
      choice: json['choice'],
      total: json['total'],
    );
  }
}

class Resultado {
  final String name;
  final List<Conteo> results;

  Resultado({required this.name, required this.results});

  factory Resultado.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List;
    List<Conteo> results = resultsList.map((i) => Conteo.fromJson(i)).toList();

    return Resultado(
      name: json['name'],
      results: results,
    );
  }
}