import 'package:flutter_app_nueva/data/models/encuesta_model.dart';
import 'package:flutter_app_nueva/data/models/voto_model.dart';
import 'package:flutter_app_nueva/data/models/resultado_model.dart';

// Define que funciones debe tener el repositorio de votaciones, pero no se preocupa de como
// funcionan por dentro.
abstract class VotacionRepository {
  Future<List<Encuesta>> getEncuestas();

  Future<Encuesta> getEncuestaPorToken(String pollToken);

  Future<void> registrarVoto(Voto voto);

  Future<Resultado> getResultados(String pollToken);
}