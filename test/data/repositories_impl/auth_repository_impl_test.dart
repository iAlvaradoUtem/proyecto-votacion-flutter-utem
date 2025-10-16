// test/data/repositories_impl/auth_repository_impl_test.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_app_nueva/data/repositories_impl/auth_repository_impl.dart';

// Importa el archivo que se generará en el siguiente paso
import 'auth_repository_impl_test.mocks.dart';

// Esta anotación le dice a Mockito qué clases necesitamos simular
@GenerateMocks([FirebaseAuth, GoogleSignIn])
void main() {
  // Declaramos las variables que usaremos en las pruebas
  late AuthRepository authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;

  // setUp se ejecuta antes de cada prueba individual
  setUp(() {
    // Creamos instancias "falsas" de los servicios de Firebase y Google
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    // Creamos nuestro repositorio, pero le pasamos las dependencias falsas
    authRepository = AuthRepository(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  // Definimos un grupo de pruebas para el cierre de sesión
  group('signOut', () {

    // Definimos una prueba específica
    test('debe llamar a signOut en GoogleSignIn y FirebaseAuth', () async {
      // Arrange: Preparamos la prueba. Le decimos a nuestros mocks que, cuando
      // se llame a signOut, no devuelvan nada (un Future<void> vacío).
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);

      // Act: Ejecutamos la función que queremos probar
      await authRepository.signOut();

      // Assert: Verificamos que los métodos esperados fueron llamados exactamente una vez.
      verify(mockGoogleSignIn.signOut()).called(1);
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}