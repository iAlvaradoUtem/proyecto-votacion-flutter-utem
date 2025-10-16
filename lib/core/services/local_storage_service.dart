import 'package:shared_preferences/shared_preferences.dart';

// Este servicio se encarga de guardar y leer datos en la memoria del telefono
// Lo usamos para el historial de votaciones
class LocalStorageService {

  // Funcion para guardar un voto. Requiere el ID del usuario para
  // crear una llave unica y no mezclar historiales
  Future<void> saveVote({
    required String userId,
    required String pollName,
    required String choiceName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userHistoryKey = 'vote_history_$userId';
    
    // Leemos el historial que ya existe, si es que hay uno
    final List<String> history = prefs.getStringList(userHistoryKey) ?? [];
    history.add('$pollName|$choiceName');
    await prefs.setStringList(userHistoryKey, history);
  }

  Future<List<String>> getVoteHistory({required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    // Leemos la informacion desde la "etiqueta" unica del usuario
    final userHistoryKey = 'vote_history_$userId';
    return prefs.getStringList(userHistoryKey) ?? [];
  }
}