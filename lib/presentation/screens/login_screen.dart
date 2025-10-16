import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/presentation/providers/auth_providers.dart';
import 'package:flutter_app_nueva/presentation/widgets/main_app_bar.dart'; // <-- Nuevo import

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // --- APPBAR ACTUALIZADO ---
      // Usamos nuestro AppBar personalizado para mantener la consistencia visual.
      appBar: const MainAppBar(),
      // -------------------------
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido a Vota UTEM',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(authRepositoryProvider).signInWithGoogle();
              },
              icon: const Icon(Icons.login), // Puedes cambiar el icono si quieres
              label: const Text('Iniciar sesión con Google'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}