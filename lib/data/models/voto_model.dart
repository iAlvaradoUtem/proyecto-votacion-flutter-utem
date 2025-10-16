// Estructura de un voto
class Voto {
  final String pollToken;
  final int selection;

  Voto({
    required this.pollToken,
    required this.selection,
  });

  // Convertir  Voto a un formato json, se envia a la api
  Map<String, dynamic> toJson() {
    return {
      'pollToken': pollToken,
      'selection': selection,
    };
  }
}