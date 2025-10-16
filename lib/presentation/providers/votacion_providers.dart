import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart'; Necesario para la version final con token dinamico
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/core/errors/exceptions.dart';
import 'package:flutter_app_nueva/data/models/encuesta_model.dart';
import 'package:flutter_app_nueva/data/models/resultado_model.dart';
import 'package:flutter_app_nueva/data/repositories_impl/votacion_repository_impl.dart';
import 'package:flutter_app_nueva/domain/repositories/votacion_repository.dart';
import 'package:flutter_app_nueva/presentation/providers/auth_providers.dart';

// Provider para el cliente Dio encargado de las llamadas api
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.sebastian.cl/vote'));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {

        // --- MODO TEMPORAL CON TOKEN ESTATICO ---
        const String tokenValido = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImZiOWY5MzcxZDU3NTVmM2UzODNhNDBhYjNhMTcyY2Q4YmFjYTUxN2YiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDc5NDQ4MzEzMzg2NTA2NTUyMjMiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImlhbHZhcmFkb0B1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJrWnJrU1kxSVppWm5pdE9KME9Vc1N3IiwibmFtZSI6IklHTkFDSU8gQU5EUkVTIEFMVkFSQURPIFRPTEVETyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NKTG5xOUdfUnhCam5NbEVFeXVlcDZtckdTd2IwbHJQU0x6TDNkSlZDZlZISXhCYnc9czk2LWMiLCJnaXZlbl9uYW1lIjoiSUdOQUNJTyBBTkRSRVMiLCJmYW1pbHlfbmFtZSI6IkFMVkFSQURPIFRPTEVETyIsImlhdCI6MTc2MDY1NDQ3OCwiZXhwIjoxNzYwNjU4MDc4fQ.Pm7dThTYp_wLb_Q2V70WRop4WCsmpnE5QifLrVxsV8aryIXVODIq9i-tNW_mGSHvVVnzIsocOQFMEMAAyLNoxK6YLe_kc5dbQMERuccZ1uFWuQH9kelg7PvpZEPtcgOuxjFSl-d-SCbrVVv1SlcrC3B3LU6SQJ76zqemWIERBzLnQzYWUUa8Vj80jqDpV4feocBvNveJy3h8F-rriggVoHhxRIIEcAwuQKcz2wvU3KI9TyzUvZ1tYlA4KIbyE3yZiYksbIc--GT8DEHoT8SP2tJx8ZrL5VyNLrpQz4fiNU-J99hew5urRCWs7lEzdHPfiVFhamiZElV7b83r62h04A";
        options.headers['Authorization'] = 'Bearer $tokenValido';
        return handler.next(options);
        // --- FIN MODO TEMPORAL ---

        /*
        // --- MODO FINAL CON TOKEN DINAMICO ---
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final idToken = await user.getIdToken();
          options.headers['Authorization'] = 'Bearer $idToken';
        }
        return handler.next(options);
        // --- FIN MODO FINAL ---
        */
      },
      onError: (DioException e, handler) {
        // Intercepta errores de red. Si es un 401, lo convierte en
        // una excepcion personalizada para manejar la sesion expirada
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

// Crea una instancia del repositorio de votaciones
final votacionRepositoryProvider = Provider<VotacionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return VotacionRepositoryImpl(dio);
});

// Obtiene la lista completa de encuestas desde la api
final allEncuestasProvider = FutureProvider.autoDispose<List<Encuesta>>((ref) {
  ref.watch(authStateProvider);
  final repository = ref.watch(votacionRepositoryProvider);
  return repository.getEncuestas();
});

// Guarda el texto actual de la barra de busqueda
final searchQueryProvider = StateProvider<String>((ref) => '');

// Devuelve la lista de encuestas filtrada por la busqueda
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

// Obtiene el detalle de una sola encuesta usando su token
final pollDetailProvider =
    FutureProvider.autoDispose.family<Encuesta, String>((ref, pollToken) {
  final repository = ref.watch(votacionRepositoryProvider);
  return repository.getEncuestaPorToken(pollToken);
});

// Obtiene los resultados de una sola encuesta usando su token
final pollResultsProvider =
    FutureProvider.autoDispose.family<Resultado, String>((ref, pollToken) {
  final repository = ref.watch(votacionRepositoryProvider);
  return repository.getResultados(pollToken);
});