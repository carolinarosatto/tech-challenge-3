import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:tech_challenge_3/core/errors/failure.dart';
import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/transactions/data/datasources/firestore_transactions_datasource.dart';
import 'package:tech_challenge_3/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/repositories/transactions_repository.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl(this._datasource);

  final FirestoreTransactionsDatasource _datasource;

  @override
  Stream<List<TransactionEntity>> watchTransactions({required String userId}) {
    return _datasource
        .watchTransactions(userId: userId)
        .map((items) => items.map(TransactionMapper.fromMap).toList());
  }

  @override
  Stream<List<TransactionEntity>> watchTransactionsPage({
    required String userId,
    required int limit,
  }) {
    return _datasource
        .watchTransactionsPage(userId: userId, limit: limit)
        .map((items) => items.map(TransactionMapper.fromMap).toList());
  }

  @override
  Future<Result<void>> saveTransaction({
    required String userId,
    required TransactionEntity transaction,
    Uint8List? imageBytes,
  }) async {
    if (transaction.amount < 0) {
      return const FailureResult(
        ValidationFailure(message: 'O valor da transação deve ser positivo.'),
      );
    }

    try {
      String? base64Image;

      if (imageBytes != null) {
        base64Image = await _datasource.compressAndConvertToBase64(imageBytes);
      }

      final transactionId = transaction.id.isNotEmpty
          ? transaction.id
          : _datasource.generateTransactionId(userId: userId);

      final transactionToSave = transaction.copyWith(
        id: transactionId,
        userId: userId,
        updatedAt: DateTime.now(),
        attachmentUrl: imageBytes == null ? transaction.attachmentUrl : null,
        attachmentBase64: base64Image ?? transaction.attachmentBase64,
      );

      await _datasource.saveTransaction(
        userId: userId,
        transactionId: transactionId,
        data: TransactionMapper.toMap(transactionToSave),
      );

      return const Success<void>(null);
    } on FirebaseException catch (error, stackTrace) {
      return FailureResult(
        DatabaseFailure(
          message: 'Erro ao salvar transação no Firestore.',
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'Erro inesperado ao salvar transação.',
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteTransaction({
    required String userId,
    required String transactionId,
  }) async {
    try {
      await _datasource.deleteTransaction(
        userId: userId,
        transactionId: transactionId,
      );
      return const Success<void>(null);
    } on FirebaseException catch (error, stackTrace) {
      return FailureResult(
        DatabaseFailure(
          message: 'Erro ao excluir transação no Firestore.',
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'Erro inesperado ao excluir transação.',
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
