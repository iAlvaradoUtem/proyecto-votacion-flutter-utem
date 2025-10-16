// Estructura de una sola opcion dentro de una encuesta
class DetalleOpcion {
  final int selection;
  final String choice;

  DetalleOpcion({required this.selection, required this.choice});

  // Crear un objeto DetalleOpcion a partir de un json
  factory DetalleOpcion.fromJson(Map<String, dynamic> json) {
    return DetalleOpcion(
      selection: json['selection'],
      choice: json['choice'],
    );
  }
}

// Estructura de una encuesta completa
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

  // Crear un objeto 'Encuesta' a partir de un json que viene de la api
  factory Encuesta.fromJson(Map<String, dynamic> json) {
    var optionsList = json['options'] as List;
    List<DetalleOpcion> options =
        optionsList.map((i) => DetalleOpcion.fromJson(i)).toList();

    return Encuesta(
      token: json['token'],
      name: json['name'],
      active: json['active'],
      owner: json['owner'] ?? false, // Si la api no envia 'owner', asumimos false
      options: options,
    );
  }
}