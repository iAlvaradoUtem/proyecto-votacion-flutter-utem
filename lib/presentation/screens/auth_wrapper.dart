import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/presentation/providers/auth_providers.dart';
import 'package:flutter_app_nueva/presentation/screens/home_screen.dart';
import 'package:flutter_app_nueva/presentation/screens/login_screen.dart';

// Envuelve la app y maneja la logica de navegacion inicial
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        // Si hay un usuario muestra la pantalla principal
        if (user != null) {
          return const HomeScreen();
        }
        // Muestra la pantalla de login
        return const LoginScreen();
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      // Si hay un error, muestra un mensaje simple
      error: (error, stackTrace) => const Scaffold(body: Center(child: Text('Ocurrio un error'))),
    );
  }
}