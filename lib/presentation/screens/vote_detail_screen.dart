import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/core/services/local_storage_service.dart';
import 'package:flutter_app_nueva/data/models/voto_model.dart';
import 'package:flutter_app_nueva/presentation/providers/auth_providers.dart';
import 'package:flutter_app_nueva/presentation/providers/votacion_providers.dart';
import 'package:flutter_app_nueva/presentation/widgets/loading_widget.dart';
import 'package:flutter_app_nueva/presentation/widgets/error_widget.dart';
import 'package:flutter_app_nueva/presentation/widgets/main_app_bar.dart';
// El import de poll_results_screen.dart ha sido eliminado.

class VoteDetailScreen extends ConsumerStatefulWidget {
  final String pollToken;
  const VoteDetailScreen({super.key, required this.pollToken});

  @override
  ConsumerState<VoteDetailScreen> createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends ConsumerState<VoteDetailScreen> {
  int? selectedOption;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pollDetailAsyncValue = ref.watch(pollDetailProvider(widget.pollToken));

    return Scaffold(
      appBar: const MainAppBar(),
      body: pollDetailAsyncValue.when(
        data: (encuesta) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(encuesta.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 24),
                  Text('Selecciona una opción:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Column(
                    children: encuesta.options.map((option) {
                      return RadioListTile<int>(
                        title: Text(option.choice),
                        value: option.selection,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: selectedOption == null
                                ? null
                                : () async {
                                    final user = ref.read(authStateProvider).value;
                                    if (user == null) return;

                                    setState(() { isLoading = true; });
                                    try {
                                      final voto = Voto(
                                        pollToken: widget.pollToken,
                                        selection: selectedOption!,
                                      );
                                      await ref.read(votacionRepositoryProvider).registrarVoto(voto);

                                      final choiceName = encuesta.options.firstWhere((opt) => opt.selection == selectedOption!).choice;
                                      await LocalStorageService().saveVote(
                                        userId: user.uid,
                                        pollName: encuesta.name,
                                        choiceName: choiceName,
                                      );

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('¡Voto registrado y guardado localmente!'), backgroundColor: Colors.green),
                                      );
                                      
                                      ref.invalidate(pollResultsProvider(widget.pollToken));
                                      if(mounted) Navigator.pop(context);

                                    } on DioException catch (e) {
                                      String errorMessage = 'Ocurrió un error inesperado.';
                                      if (e.response?.statusCode == 500 &&
                                          e.response?.data.toString().contains('ya registra un voto') == true) {
                                        errorMessage = 'Ya emitiste tu voto en esta encuesta.';
                                      }
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(errorMessage), backgroundColor: Colors.orange),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error al registrar el voto: $e'), backgroundColor: Colors.red),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() { isLoading = false; });
                                      }
                                    }
                                  },
                            child: const Text('Votar'),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (err, stack) => ErrorRetryWidget(
          errorMessage: 'Error al cargar el detalle de la encuesta.',
          onRetry: () {
            ref.invalidate(pollDetailProvider(widget.pollToken));
          },
        ),
      ),
    );
  }
}