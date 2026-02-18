import 'dart:typed_data';

import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';

abstract class TransactionsRepository {
  Stream<List<TransactionEntity>> watchTransactions({required String userId});

  Stream<List<TransactionEntity>> watchTransactionsPage({
    required String userId,
    required int limit,
  });

  Future<Result<void>> saveTransaction({
    required String userId,
    required TransactionEntity transaction,
    Uint8List? imageBytes,
  });

  Future<Result<void>> deleteTransaction({
    required String userId,
    required String transactionId,
  });
}
