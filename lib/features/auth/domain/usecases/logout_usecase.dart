import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> execute() {
    return _repository.logout();
  }
}
