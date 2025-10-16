class DetalleOpcion {
  final int selection;
  final String choice;

  DetalleOpcion({required this.selection, required this.choice});

  factory DetalleOpcion.fromJson(Map<String, dynamic> json) {
    return DetalleOpcion(
      selection: json['selection'],
      choice: json['choice'],
    );
  }
}

class Encuesta {
  final String token;
  final String name;
  final bool active;
  final bool owner;
  final List<DetalleOpcion> options;

  Encuesta({
    required this.token,
    required this.name,
    required this.active,
    required this.owner,
    required this.options,
  });

  factory Encuesta.fromJson(Map<String, dynamic> json) {
    var optionsList = json['options'] as List;
    List<DetalleOpcion> options =
        optionsList.map((i) => DetalleOpcion.fromJson(i)).toList();

    return Encuesta(
      token: json['token'],
      name: json['name'],
      active: json['active'],
      owner: json['owner'] ?? false,
      options: options,
    );
  }
}