import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tech_challenge_3/core/errors/failure.dart';
import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/auth/presentation/widgets/auth_guard.dart';
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

  @override
  Future<Result<AuthUserEntity>> login({
    required String email,
    required String password,
  }) async {
    return const FailureResult(AuthFailure(message: 'not used'));
  }

  @override
  Future<Result<void>> logout() async {
    return const Success<void>(null);
  }

  @override
  Future<Result<AuthUserEntity>> register({
    required String email,
    required String password,
  }) async {
    return const FailureResult(AuthFailure(message: 'not used'));
  }

  @override
  Stream<AuthUserEntity?> watchAuthState() => _controller.stream;

  void emit(AuthUserEntity? user) => _controller.add(user);

  Future<void> dispose() async {
    await _controller.close();
  }
}

void main() {
  testWidgets('AuthGuard renders child when user is authenticated', (
    WidgetTester tester,
  ) async {
    final repository = _FakeAuthRepository();
    final provider = AuthProvider(
      loginUseCase: LoginUseCase(repository),
      registerUseCase: RegisterUseCase(repository),
      logoutUseCase: LogoutUseCase(repository),
      watchAuthStateUseCase: WatchAuthStateUseCase(repository),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: AuthGuard(child: Text('Protected content')),
        ),
      ),
    );

    repository.emit(const AuthUserEntity(uid: 'uid-1', email: 'user@mail.com'));
    await tester.pump();

    expect(find.text('Protected content'), findsOneWidget);

    provider.dispose();
    await repository.dispose();
  });
}
