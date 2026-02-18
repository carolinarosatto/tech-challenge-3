import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_challenge_3/core/errors/failure.dart';
import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:tech_challenge_3/features/auth/domain/entities/auth_user_entity.dart';
import 'package:tech_challenge_3/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource);

  final FirebaseAuthDatasource _datasource;

  @override
  Stream<AuthUserEntity?> watchAuthState() {
    return _datasource.watchAuthState().map(_mapUser);
  }

  @override
  Future<Result<AuthUserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _datasource.login(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return const FailureResult(
          AuthFailure(message: 'Não foi possível autenticar o usuário.'),
        );
      }
      return Success(_mapUser(user)!);
    } on FirebaseAuthException catch (error, stackTrace) {
      return FailureResult(
        AuthFailure(
          message: _mapAuthError(error.code),
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'Erro inesperado ao realizar login.',
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<AuthUserEntity>> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _datasource.register(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return const FailureResult(
          AuthFailure(message: 'Não foi possível criar o usuário.'),
        );
      }
      return Success(_mapUser(user)!);
    } on FirebaseAuthException catch (error, stackTrace) {
      return FailureResult(
        AuthFailure(
          message: _mapAuthError(error.code),
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'Erro inesperado ao criar usuário.',
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _datasource.logout();
      return const Success<void>(null);
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'Erro ao fazer logout.',
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  AuthUserEntity? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AuthUserEntity(uid: user.uid, email: user.email);
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'E-mail ou senha incorretos.';
      case 'invalid-email':
        return 'Formato de e-mail inválido.';
      case 'internal-error':
        return 'Erro interno. Tente novamente.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      default:
        return 'Erro de autenticação: $code';
    }
  }
}
