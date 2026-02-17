import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/transactions/domain/repositories/transactions_repository.dart';

class DeleteTransactionUseCase {
  DeleteTransactionUseCase(this._repository);

  final TransactionsRepository _repository;

  Future<Result<void>> execute({
    required String userId,
    required String transactionId,
  }) {
    return _repository.deleteTransaction(
      userId: userId,
      transactionId: transactionId,
    );
  }
}
