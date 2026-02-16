import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tech_challenge_3/core/errors/failure.dart';
import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/auth/domain/entities/auth_user_entity.dart';
import 'package:tech_challenge_3/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/login_usecase.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/register_usecase.dart';
import 'package:tech_challenge_3/features/auth/domain/usecases/watch_auth_state_usecase.dart';
import 'package:tech_challenge_3/features/auth/presentation/providers/auth_provider.dart';

class _FakeAuthRepository implements AuthRepository {
  final StreamController<AuthUserEntity?> _controller =
      StreamController<AuthUserEntity?>.broadcast();

  Result<AuthUserEntity> loginResponse = const FailureResult(
    AuthFailure(message: 'Credenciais inválidas'),
  );
  Result<AuthUserEntity> registerResponse = const FailureResult(
    AuthFailure(message: 'Erro no cadastro'),
  );
  Result<void> logoutResponse = const Success<void>(null);

  @override
  Future<Result<AuthUserEntity>> login({
    required String email,
    required String password,
  }) async {
    return loginResponse;
  }

  @override
  Future<Result<void>> logout() async {
    return logoutResponse;
  }

  @override
  Future<Result<AuthUserEntity>> register({
    required String email,
    required String password,
  }) async {
    return registerResponse;
  }

  @override
  Stream<AuthUserEntity?> watchAuthState() => _controller.stream;

  void emit(AuthUserEntity? user) {
    _controller.add(user);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

void main() {
  group('AuthProvider', () {
    test('login success returns true and keeps error null', () async {
      final repository = _FakeAuthRepository();
      repository.loginResponse = const Success(
        AuthUserEntity(uid: 'uid-success', email: 'success@mail.com'),
      );
      final provider = AuthProvider(
        loginUseCase: LoginUseCase(repository),
        registerUseCase: RegisterUseCase(repository),
        logoutUseCase: LogoutUseCase(repository),
        watchAuthStateUseCase: WatchAuthStateUseCase(repository),
      );

      final result = await provider.login(
        email: 'success@mail.com',
        password: '123456',
      );

      expect(result, isTrue);
      expect(provider.errorMessage, isNull);

      provider.dispose();
      await repository.dispose();
    });

    test('updates status to authenticated when stream emits a user', () async {
      final repository = _FakeAuthRepository();
      final provider = AuthProvider(
        loginUseCase: LoginUseCase(repository),
        registerUseCase: RegisterUseCase(repository),
        logoutUseCase: LogoutUseCase(repository),
        watchAuthStateUseCase: WatchAuthStateUseCase(repository),
      );

      repository.emit(const AuthUserEntity(uid: 'uid-1', email: 'a@b.com'));
      await Future<void>.delayed(Duration.zero);

      expect(provider.status, AuthStatus.authenticated);
      expect(provider.user?.uid, 'uid-1');

      provider.dispose();
      await repository.dispose();
    });

    test('login failure returns false and exposes error message', () async {
      final repository = _FakeAuthRepository();
      repository.loginResponse = const FailureResult(
        AuthFailure(message: 'E-mail ou senha incorretos.'),
      );

      final provider = AuthProvider(
        loginUseCase: LoginUseCase(repository),
        registerUseCase: RegisterUseCase(repository),
        logoutUseCase: LogoutUseCase(repository),
        watchAuthStateUseCase: WatchAuthStateUseCase(repository),
      );

      final result = await provider.login(
        email: 'test@mail.com',
        password: '123456',
      );

      expect(result, isFalse);
      expect(provider.errorMessage, 'E-mail ou senha incorretos.');

      provider.dispose();
      await repository.dispose();
    });

    test('logout failure exposes error message', () async {
      final repository = _FakeAuthRepository();
      repository.logoutResponse = const FailureResult(
        UnknownFailure(message: 'Erro ao fazer logout.'),
      );
      final provider = AuthProvider(
        loginUseCase: LoginUseCase(repository),
        registerUseCase: RegisterUseCase(repository),
        logoutUseCase: LogoutUseCase(repository),
        watchAuthStateUseCase: WatchAuthStateUseCase(repository),
      );

      await provider.logout();

      expect(
        provider.errorMessage,
        'Ocorreu um erro inesperado. Tente novamente.',
      );

      provider.dispose();
      await repository.dispose();
    });
  });
}
