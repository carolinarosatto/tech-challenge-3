import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Stream<AuthUserEntity?> watchAuthState();

  Future<Result<AuthUserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<AuthUserEntity>> register({
    required String email,
    required String password,
  });

  Future<Result<void>> logout();
}
