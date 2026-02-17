import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/repositories/transactions_repository.dart';

class WatchTransactionsPageUseCase {
  WatchTransactionsPageUseCase(this._repository);

  final TransactionsRepository _repository;

  Stream<List<TransactionEntity>> execute({
    required String userId,
    required int limit,
  }) {
    return _repository.watchTransactionsPage(userId: userId, limit: limit);
  }
}
