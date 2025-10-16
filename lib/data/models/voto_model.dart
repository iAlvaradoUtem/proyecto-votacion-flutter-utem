class Voto {
  final String pollToken;
  final int selection;

  Voto({
    required this.pollToken,
    required this.selection,
  });

  // Esta función convierte nuestro objeto Voto a JSON para enviarlo a la API
  Map<String, dynamic> toJson() {
    return {
      'pollToken': pollToken,
      'selection': selection,
    };
  }
}