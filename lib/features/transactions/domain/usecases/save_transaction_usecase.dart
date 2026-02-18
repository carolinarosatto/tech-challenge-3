import 'dart:typed_data';

import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/repositories/transactions_repository.dart';

class SaveTransactionUseCase {
  SaveTransactionUseCase(this._repository);

  final TransactionsRepository _repository;

  Future<Result<void>> execute({
    required String userId,
    required TransactionEntity transaction,
    Uint8List? imageBytes,
  }) {
    return _repository.saveTransaction(
      userId: userId,
      transaction: transaction,
      imageBytes: imageBytes,
    );
  }
}
