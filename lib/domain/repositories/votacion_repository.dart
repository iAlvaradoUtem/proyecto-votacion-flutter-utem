import 'package:flutter_app_nueva/data/models/encuesta_model.dart';
import 'package:flutter_app_nueva/data/models/voto_model.dart'; // <-- Nuevo import
import 'package:flutter_app_nueva/data/models/resultado_model.dart'; // <-- Nuevo import

abstract class VotacionRepository {
  Future<List<Encuesta>> getEncuestas();
  Future<Encuesta> getEncuestaPorToken(String pollToken);
  Future<void> registrarVoto(Voto voto); // <-- AÑADE ESTA LÍNEA
  Future<Resultado> getResultados(String pollToken); // <-- AÑADE ESTA LÍNEA
}