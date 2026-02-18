import 'package:tech_challenge_3/features/auth/domain/entities/auth_user_entity.dart';
import 'package:tech_challenge_3/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  WatchAuthStateUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AuthUserEntity?> execute() {
    return _repository.watchAuthState();
  }
}
