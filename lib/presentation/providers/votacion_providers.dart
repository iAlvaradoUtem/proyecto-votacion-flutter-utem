import 'package:dio/dio.dart';
//import 'package:firebase_auth/firebase_auth.dart'; // Import is needed for the final code
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/core/errors/exceptions.dart';
import 'package:flutter_app_nueva/data/models/encuesta_model.dart';
import 'package:flutter_app_nueva/data/models/resultado_model.dart';
import 'package:flutter_app_nueva/data/repositories_impl/votacion_repository_impl.dart';
import 'package:flutter_app_nueva/domain/repositories/votacion_repository.dart';
import 'package:flutter_app_nueva/presentation/providers/auth_providers.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.sebastian.cl/vote'));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async { // onRequest is now async

        // =======================================================================
        // MODO TEMPORAL (USANDO TOKEN ESTÁTICO)
        // Usa este bloque para el desarrollo mientras no tienes el Firebase correcto.
        // =======================================================================
        const String tokenValido = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImZiOWY5MzcxZDU3NTVmM2UzODNhNDBhYjNhMTcyY2Q4YmFjYTUxN2YiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDc5NDQ4MzEzMzg2NTA2NTUyMjMiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImlhbHZhcmFkb0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJRa2dKVzExdTladVctSDh6Qk8zNndBIiwibmFtZSI6IklHTkFDSU8gQU5EUkVTIEFMVkFSQURPIFRPTEVETyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NKTG5xOUdfUnhCam5NbEVFeXVlcDZtckdTd2IwbHJQU0x6TDNkSlZDZlZISXhCYnc9czk2LWMiLCJnaXZlbl9uYW1lIjoiSUdOQUNJTyBBTkRSRVMiLCJmYW1pbHlfbmFtZSI6IkFMVkFSQURPIFRPTEVETyIsImlhdCI6MTc2MDY0NTc5MSwiZXhwIjoxNzYwNjQ5MzkxfQ.oFe3P407N8RktmjaKisPmZ5l-MQunBWZdP52T06PCkdSLQ5Xd7QcvgKE35i_PPKDQsMcILtPXTFETeP6gWNj5m2ZztdAkN7imCOgVzeEPB6z_jY1TBlBz2z1Ggd5yiZ0Fi_x7XnWcto904kHTnOBqLcR2q-pwWF6hLYDey4HekVJmpBox5tY_dTo3wjBRHL2wLq5sYC0o_-g1kPli4RkRnsN7V5jE4QD5i3DtzEUDxEbduINPnKX6PhWlxBG4YBy4F3hPYpSzQjTq7eJaXLYHmpKEqZDsLYXwqEpnDmiavV5mnTyoQCjvVFf0ojAxdDJX9cUvW3Dfa-9GNJ_zbsd-g";
        options.headers['Authorization'] = 'Bearer $tokenValido';
        return handler.next(options);
        // =======================================================================


        /*
        // =======================================================================
        // MODO FINAL (USANDO TOKEN DINÁMICO DE FIREBASE)
        // Cuando hables con tu profesor, borra el bloque de arriba y descomenta este.
        // =======================================================================
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final idToken = await user.getIdToken();
          options.headers['Authorization'] = 'Bearer $idToken';
        }
        return handler.next(options);
        // =======================================================================
        */
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: SessionExpiredException(),
            ),
          );
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});

// The rest of the providers remain exactly the same.
final votacionRepositoryProvider = Provider<VotacionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return VotacionRepositoryImpl(dio);
});

final allEncuestasProvider = FutureProvider.autoDispose<List<Encuesta>>((ref) {
  ref.watch(authStateProvider);
  final repository = ref.watch(votacionRepositoryProvider);
  return repository.getEncuestas();
});

final filteredEncuestasProvider = Provider.autoDispose<List<Encuesta>>((ref) {
  final allEncuestas = ref.watch(allEncuestasProvider).value ?? [];
  final query = ref.watch(searchQueryProvider).toLowerCase();

  if (query.isEmpty) {
    return allEncuestas;
  }

  return allEncuestas.where((encuesta) {
    return encuesta.name.toLowerCase().contains(query);
  }).toList();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final pollDetailProvider =
    FutureProvider.autoDispose.family<Encuesta, String>((ref, pollToken) {
  final repository = ref.watch(votacionRepositoryProvider);
  return repository.getEncuestaPorToken(pollToken);
});

final pollResultsProvider =
    FutureProvider.autoDispose.family<Resultado, String>((ref, pollToken) {
  final repository = ref.watch(votacionRepositoryProvider);
  return repository.getResultados(pollToken);
});