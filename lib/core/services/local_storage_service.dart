import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // Ya no usamos una llave estática aquí.

  // La función ahora requiere el ID del usuario
  Future<void> saveVote({
    required String userId,
    required String pollName,
    required String choiceName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    // Creamos una llave única para el historial de este usuario
    final userHistoryKey = 'vote_history_$userId';
    
    final List<String> history = prefs.getStringList(userHistoryKey) ?? [];
    history.add('$pollName|$choiceName');
    await prefs.setStringList(userHistoryKey, history);
  }

  // La función ahora requiere el ID del usuario
  Future<List<String>> getVoteHistory({required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    // Leemos desde la llave única del usuario
    final userHistoryKey = 'vote_history_$userId';
    return prefs.getStringList(userHistoryKey) ?? [];
  }
}