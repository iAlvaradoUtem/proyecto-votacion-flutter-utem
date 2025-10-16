import 'package:dio/dio.dart';
import 'package:flutter_app_nueva/data/models/encuesta_model.dart';
import 'package:flutter_app_nueva/data/models/resultado_model.dart';
import 'package:flutter_app_nueva/data/models/voto_model.dart';
import 'package:flutter_app_nueva/domain/repositories/votacion_repository.dart';

// Aca nos conectamos a la api para obtener y enviar datos relacionados con las encuestas
class VotacionRepositoryImpl implements VotacionRepository {
  final Dio _dio;

  VotacionRepositoryImpl(this._dio);

  // Obtener la lista de encuestas disponibles
  @override
  Future<List<Encuesta>> getEncuestas() async {
    try {
      final response = await _dio.get('/v1/polls/');
      final List<dynamic> data = response.data;
      return data.map((json) => Encuesta.fromJson(json)).toList();
    } on DioException {
      rethrow;
    }
  }

  // Obtener los detalles de una encuesta especifica usando token
  @override
  Future<Encuesta> getEncuestaPorToken(String pollToken) async {
    try {
      final response = await _dio.get('/v1/polls/$pollToken');
      return Encuesta.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  // Enviar voto a la api para ser registrado
  @override
  Future<void> registrarVoto(Voto voto) async {
    try {
      await _dio.post(
        '/v1/vote/election',
        data: voto.toJson(),
      );
    } on DioException {
      rethrow;
    }
  }

  // Resultados de una encuesta especifica
  @override
  Future<Resultado> getResultados(String pollToken) async {
    try {
      final response = await _dio.get('/v1/vote/$pollToken/results');
      return Resultado.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }
}