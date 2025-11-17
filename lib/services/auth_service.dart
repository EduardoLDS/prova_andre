import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Login
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Usuário logado: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Erro de login: ${e.message}');
      return null;
    }
  }

  Future<User?> createUserWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Usuário criado: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Erro ao criar: ${e.message}');
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await auth.signOut();
    print('Usuário deslogado.');
  }

  // Usuário atual
  User? get currentUser => auth.currentUser;

  // Status de autenticação (stream)
  Stream<User?> get authStateChanges => auth.authStateChanges();
}
