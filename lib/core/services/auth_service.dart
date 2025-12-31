import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'success': true,
        'message': 'Login realizado com sucesso',
        'user': userCredential.user?.email,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          errorMessage = 'E-mail ou senha incorretos.';
          break;
        case 'invalid-email':
          errorMessage = 'Formato de e-mail inválido.';
          break;
        case 'internal-error':
          errorMessage = 'Erro interno. Tente novamente.';
          break;
        default:
          errorMessage = 'Erro desconhecido: ${e.code}';
      }

      return {'success': false, 'code': e.code, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return {
        'success': true,
        'message': 'Usuário criado com sucesso',
        'user': userCredential.user?.email,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Este e-mail já está cadastrado.';
          break;
        case 'invalid-email':
          errorMessage = 'Formato de e-mail inválido.';
          break;
        case 'weak-password':
          errorMessage = 'A senha deve ter pelo menos 6 caracteres.';
          break;
        default:
          errorMessage = 'Erro ao criar usuário: ${e.code}';
      }

      return {'success': false, 'code': e.code, 'message': errorMessage};
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
