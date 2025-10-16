import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/presentation/providers/votacion_providers.dart';
import 'package:flutter_app_nueva/presentation/widgets/loading_widget.dart';
import 'package:flutter_app_nueva/presentation/widgets/error_widget.dart';
import 'package:flutter_app_nueva/presentation/widgets/main_app_bar.dart';

class PollResultsScreen extends ConsumerWidget {
  final String pollToken;
  const PollResultsScreen({super.key, required this.pollToken});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsyncValue = ref.watch(pollResultsProvider(pollToken));
    return Scaffold(
      appBar: const MainAppBar(),
      body: resultsAsyncValue.when(
        data: (resultado) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                resultado.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              ...resultado.results.map((conteo) => ListTile(
                    title: Text(conteo.choice),
                    trailing: Text(
                      '${conteo.total} Votos',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (err, stack) => ErrorRetryWidget(
          errorMessage: 'Error al cargar los resultados',
          onRetry: () {
            ref.invalidate(pollResultsProvider(pollToken));
          },
        ),
      ),
    );
  }
}