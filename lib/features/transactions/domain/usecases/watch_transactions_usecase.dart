import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/repositories/transactions_repository.dart';

class WatchTransactionsUseCase {
  WatchTransactionsUseCase(this._repository);

  final TransactionsRepository _repository;

  Stream<List<TransactionEntity>> execute({required String userId}) {
    return _repository.watchTransactions(userId: userId);
  }
}
