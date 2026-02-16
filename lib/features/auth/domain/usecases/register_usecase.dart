import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/auth/domain/entities/auth_user_entity.dart';
import 'package:tech_challenge_3/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthUserEntity>> execute({
    required String email,
    required String password,
  }) {
    return _repository.register(email: email, password: password);
  }
}
