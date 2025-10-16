import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_nueva/data/repositories_impl/auth_repository_impl.dart';

// Crea una unica instancia de AuthRepository para toda la app.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Expone el estado de autenticacion del usuario.
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});