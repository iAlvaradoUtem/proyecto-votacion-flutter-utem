import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/presentation/providers/votacion_providers.dart';
import 'package:flutter_app_nueva/presentation/widgets/error_widget.dart';
import 'package:flutter_app_nueva/presentation/widgets/loading_widget.dart';
import 'package:flutter_app_nueva/presentation/widgets/poll_card.dart';

// Lista de encuestas para ver resultados
class ResultsListScreen extends ConsumerWidget {
  const ResultsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usa los mismos providers que la pantalla de Votar
    final allEncuestasAsync = ref.watch(allEncuestasProvider);
    final filteredEncuestas = ref.watch(filteredEncuestasProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar resultados de encuesta...',
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
                return Center(
                  child: Text(
                    ref.watch(searchQueryProvider).isEmpty
                        ? 'No hay encuestas disponibles'
                        : 'No se encontraron resultados',
                  ),
                );
              }
              return ListView.builder(
                itemCount: filteredEncuestas.length,
                itemBuilder: (context, index) {
                  final encuesta = filteredEncuestas[index];
                  // Le indicamos a la tarjeta que esta en modo 'resultados'
                  return PollCard(
                    encuesta: encuesta,
                    mode: CardMode.results,
                  );
                },
              );
            },
            loading: () => const LoadingWidget(),
            error: (error, stackTrace) => ErrorRetryWidget(
              errorMessage: 'Error al cargar las encuestas',
              onRetry: () {
                ref.invalidate(allEncuestasProvider);
              },
            ),
          ),
        ),
      ],
    );
  }
}