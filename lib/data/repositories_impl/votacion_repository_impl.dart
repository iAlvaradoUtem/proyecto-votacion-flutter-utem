import 'package:dio/dio.dart';
import 'package:flutter_app_nueva/data/models/encuesta_model.dart';
import 'package:flutter_app_nueva/data/models/resultado_model.dart';
import 'package:flutter_app_nueva/data/models/voto_model.dart';
import 'package:flutter_app_nueva/domain/repositories/votacion_repository.dart';

class VotacionRepositoryImpl implements VotacionRepository {
  final Dio _dio;

  VotacionRepositoryImpl(this._dio);

  @override
  Future<List<Encuesta>> getEncuestas() async {
    try {
      final response = await _dio.get('/v1/polls/');
      final List<dynamic> data = response.data;
      return data.map((json) => Encuesta.fromJson(json)).toList();
    } on DioException catch (e) {
      print('❌ ERROR EN EL REPOSITORIO (getEncuestas): $e');
      rethrow;
    }
  }

  @override
  Future<Encuesta> getEncuestaPorToken(String pollToken) async {
    try {
      final response = await _dio.get('/v1/polls/$pollToken');
      return Encuesta.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ ERROR EN EL REPOSITORIO (getEncuestaPorToken): $e');
      rethrow;
    }
  }

  @override
  Future<void> registrarVoto(Voto voto) async {
    try {
      await _dio.post(
        '/v1/vote/election',
        data: voto.toJson(),
      );
    } on DioException catch (e) {
      print('❌ ERROR EN EL REPOSITORIO (registrarVoto): $e');
      rethrow;
    }
  }

  // --- IMPLEMENTACIÓN AÑADIDA ---
  @override
  Future<Resultado> getResultados(String pollToken) async {
    try {
      // Llama al endpoint correcto para obtener los resultados
      final response = await _dio.get('/v1/vote/$pollToken/results');
      // Parsea la respuesta usando el modelo de Resultado
      return Resultado.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ ERROR EN EL REPOSITORIO (getResultados): ${e.response}');
      rethrow;
    }
  }
}