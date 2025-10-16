import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // Comprueba si el usuario está conectado o no
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Inicia sesion con google
  Future<void> signInWithGoogle() async {
    try {
      // Muestra la ventana de Google para elegir una cuenta.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      // Una vez que el usuario elige una cuenta, usamos esa información
      // para que Firebase lo reconozca.
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  // Cierra la sesion del usuario
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}