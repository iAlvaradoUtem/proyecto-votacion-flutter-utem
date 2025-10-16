import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/core/errors/exceptions.dart';
import 'package:flutter_app_nueva/presentation/providers/auth_providers.dart';
import 'package:flutter_app_nueva/presentation/providers/votacion_providers.dart';
import 'package:flutter_app_nueva/presentation/widgets/error_widget.dart';
import 'package:flutter_app_nueva/presentation/widgets/loading_widget.dart';
import 'package:flutter_app_nueva/presentation/widgets/poll_card.dart';

class VoteListScreen extends ConsumerWidget {
  const VoteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha los cambios en el provider para reaccionar a errores de sesion
    ref.listen(allEncuestasProvider, (_, state) {
      if (state is AsyncError) {
        final error = state.error;
        if (error is DioException && error.error is SessionExpiredException) {
          // Muestra la notificacion
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tu sesion ha expirado. Por favor, inicia sesion de nuevo'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
          // Cierra la sesion del usuario
          ref.read(authRepositoryProvider).signOut();
        }
      }
    });

    final allEncuestasAsync = ref.watch(allEncuestasProvider);
    final filteredEncuestas = ref.watch(filteredEncuestasProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar encuesta',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onChanged: (query) {
              ref.read(searchQueryProvider.notifier).state = query;
            },
          ),
        ),
        Expanded(
          child: allEncuestasAsync.when(
            data: (_) {
              if (filteredEncuestas.isEmpty) {
                final searchQuery = ref.watch(searchQueryProvider);
                // Muestra un mensaje diferente si la lista esta vacia
                // o si la busqueda no arrojo resultados
                return Center(
                  child: Text(
                    searchQuery.isEmpty
                        ? 'No hay encuestas disponibles en este momento'
                        : 'No se encontraron resultados para "$searchQuery"',
                  ),
                );
              }
              // ------------------------------------------
              return ListView.builder(
                itemCount: filteredEncuestas.length,
                itemBuilder: (context, index) {
                  final encuesta = filteredEncuestas[index];
                  return PollCard(
                    encuesta: encuesta,
                    mode: CardMode.vote,
                  );
                },
              );
            },
            loading: () => const LoadingWidget(),
            error: (error, stackTrace) {
              if (error is DioException && error.error is SessionExpiredException) {
                return const LoadingWidget();
              }
              // Para cualquier otro error, muestra el widget de reintentar
              return ErrorRetryWidget(
                errorMessage: 'Error al cargar las encuestas',
                onRetry: () {
                  ref.invalidate(allEncuestasProvider);
                },
              );
              // ------------------------------------------
            },
          ),
        ),
      ],
    );
  }
}