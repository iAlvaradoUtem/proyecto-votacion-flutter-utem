import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/core/services/local_storage_service.dart';
import 'package:flutter_app_nueva/presentation/providers/auth_providers.dart';
import 'package:flutter_app_nueva/presentation/widgets/loading_widget.dart';
import 'package:flutter_app_nueva/presentation/widgets/error_widget.dart';

// Muestra la informacion del perfil del usuario
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final localStorageService = LocalStorageService();

    return Scaffold(
      body: authState.when(
        data: (user) {
          if (user == null) {
            return ErrorRetryWidget(
              errorMessage: 'No se ha iniciado sesion',
              onRetry: () {
                ref.invalidate(authStateProvider);
              },
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Center(
                child: Column(
                  children: [
                    // Muestra la foto de perfil del usuario
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : null,
                      child: user.photoURL == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Muestra el nombre del usuario
                    Text(
                      user.displayName ?? 'Sin nombre',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    // Muestra el correo del usuario
                    Text(
                      user.email ?? 'Sin correo electronico',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Divider(height: 48),
              Text(
                'Historial de Votaciones',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '(Guardado localmente en este dispositivo)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              
              // Carga y muestra el historial de votaciones guardado localmente
              FutureBuilder<List<String>>(
                future: localStorageService.getVoteHistory(userId: user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  }
                  if (snapshot.hasError) {
                    return const Text('Error al cargar el historial');
                  }
                  final history = snapshot.data ?? [];
                  if (history.isEmpty) {
                    return const Center(child: Text('Aun no has realizado ninguna votacion'));
                  }
                  // Si hay datos, construye la lista de votos
                  return Column(
                    children: history.map((voteString) {
                      final parts = voteString.split('|');
                      final pollName = parts[0];
                      final choiceName = parts[1];
                      return ListTile(
                        leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                        title: Text(pollName),
                        subtitle: Text('Tu voto: $choiceName'),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 48),
              // Boton para cerrar la sesion del usuario
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(authRepositoryProvider).signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesion'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (err, stack) => ErrorRetryWidget(
          errorMessage: 'Error al cargar el perfil',
          onRetry: () {
            ref.invalidate(authStateProvider);
          },
        ),
      ),
    );
  }
}