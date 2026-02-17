import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tech_challenge_3/core/result/result.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transactions_filter_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/calculate_totals_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/watch_transactions_page_usecase.dart';
import 'package:tech_challenge_3/features/transactions/domain/usecases/watch_transactions_usecase.dart';
import 'package:tech_challenge_3/features/transactions/presentation/providers/transactions_pagination_controller.dart';
import 'package:tech_challenge_3/features/transactions/presentation/providers/transactions_provider.dart';

class _FakeTransactionsRepository implements TransactionsRepository {
  List<TransactionEntity> allTransactions = [];
  Result<void> saveResult = const Success<void>(null);
  Result<void> deleteResult = const Success<void>(null);

  TransactionEntity? lastSavedTransaction;
  Uint8List? lastSavedImageBytes;
  String? lastSaveUserId;
  String? lastDeleteUserId;
  String? lastDeletedTransactionId;
  int? lastPageLimit;

  @override
  Stream<List<TransactionEntity>> watchTransactions({required String userId}) {
    return Stream.value(List<TransactionEntity>.from(allTransactions));
  }

  @override
  Stream<List<TransactionEntity>> watchTransactionsPage({
    required String userId,
    required int limit,
  }) {
    lastPageLimit = limit;
    return Stream.value(allTransactions.take(limit).toList(growable: false));
  }

  @override
  Future<Result<void>> saveTransaction({
    required String userId,
    required TransactionEntity transaction,
    Uint8List? imageBytes,
  }) async {
    lastSaveUserId = userId;
    lastSavedTransaction = transaction;
    lastSavedImageBytes = imageBytes;
    return saveResult;
  }

  @override
  Future<Result<void>> deleteTransaction({
    required String userId,
    required String transactionId,
  }) async {
    lastDeleteUserId = userId;
    lastDeletedTransactionId = transactionId;
    return deleteResult;
  }
}

TransactionEntity _transaction({
  required String id,
  required TransactionType type,
  required TransactionCategory category,
}) {
  return TransactionEntity(
    id: id,
    userId: 'user-1',
    category: category,
    type: type,
    title: 'Transação $id',
    description: 'Descrição $id',
    amount: 100,
    createdAt: DateTime(2026, 1, 1),
  );
}

TransactionsProvider _buildProvider(_FakeTransactionsRepository repository) {
  return TransactionsProvider(
    userId: 'user-1',
    watchTransactionsUseCase: WatchTransactionsUseCase(repository),
    watchTransactionsPageUseCase: WatchTransactionsPageUseCase(repository),
    saveTransactionUseCase: SaveTransactionUseCase(repository),
    deleteTransactionUseCase: DeleteTransactionUseCase(repository),
    calculateTotalsUseCase: const CalculateTotalsUseCase(),
    paginationController: TransactionsPaginationController(
      minimumLoadingDuration: Duration.zero,
    ),
  );
}

void main() {
  group('TransactionsProvider', () {
    test(
      'saveTransaction without attachment delegates to repository',
      () async {
        final repository = _FakeTransactionsRepository();
        final provider = _buildProvider(repository);

        await Future<void>.delayed(Duration.zero);

        final result = await provider.saveTransaction(
          transaction: _transaction(
            id: '1',
            type: TransactionType.payment,
            category: TransactionCategory.food,
          ),
        );

        expect(result, isTrue);
        expect(repository.lastSaveUserId, 'user-1');
        expect(repository.lastSavedTransaction?.id, '1');
        expect(repository.lastSavedImageBytes, isNull);

        provider.dispose();
      },
    );

    test('saveTransaction with attachment delegates image bytes', () async {
      final repository = _FakeTransactionsRepository();
      final provider = _buildProvider(repository);
      final imageBytes = Uint8List.fromList([1, 2, 3]);

      await Future<void>.delayed(Duration.zero);

      final result = await provider.saveTransaction(
        transaction: _transaction(
          id: '2',
          type: TransactionType.transfer,
          category: TransactionCategory.transport,
        ),
        imageBytes: imageBytes,
      );

      expect(result, isTrue);
      expect(repository.lastSavedImageBytes, imageBytes);

      provider.dispose();
    });

    test('deleteTransaction delegates id and userId to repository', () async {
      final repository = _FakeTransactionsRepository();
      final provider = _buildProvider(repository);

      await Future<void>.delayed(Duration.zero);

      await provider.deleteTransaction('tx-delete');

      expect(repository.lastDeleteUserId, 'user-1');
      expect(repository.lastDeletedTransactionId, 'tx-delete');

      provider.dispose();
    });

    test('applies filters by direction, type and category', () async {
      final repository = _FakeTransactionsRepository();
      repository.allTransactions = [
        _transaction(
          id: 'income',
          type: TransactionType.deposit,
          category: TransactionCategory.deposit,
        ),
        _transaction(
          id: 'food',
          type: TransactionType.payment,
          category: TransactionCategory.food,
        ),
        _transaction(
          id: 'transport',
          type: TransactionType.transfer,
          category: TransactionCategory.transport,
        ),
      ];
      final provider = _buildProvider(repository);

      await Future<void>.delayed(Duration.zero);

      provider.updateFilters(
        const TransactionsFilterEntity(direction: TransactionDirection.expense),
      );
      await Future<void>.delayed(Duration.zero);
      expect(
        provider.pagedFilteredTransactions.every(
          (transaction) =>
              transaction.type.direction == TransactionDirection.expense,
        ),
        isTrue,
      );

      provider.updateFilters(
        const TransactionsFilterEntity(types: {TransactionType.transfer}),
      );
      await Future<void>.delayed(Duration.zero);
      expect(provider.pagedFilteredTransactions.length, 1);
      expect(provider.pagedFilteredTransactions.first.id, 'transport');

      provider.updateFilters(
        const TransactionsFilterEntity(categories: {TransactionCategory.food}),
      );
      await Future<void>.delayed(Duration.zero);
      expect(provider.pagedFilteredTransactions.length, 1);
      expect(provider.pagedFilteredTransactions.first.id, 'food');

      provider.dispose();
    });

    test('loadMore updates hasMore when final page is reached', () async {
      final repository = _FakeTransactionsRepository();
      repository.allTransactions = List<TransactionEntity>.generate(
        8,
        (index) => _transaction(
          id: '$index',
          type: TransactionType.payment,
          category: TransactionCategory.other,
        ),
      );
      final provider = _buildProvider(repository);

      await Future<void>.delayed(Duration.zero);

      expect(provider.hasMore, isTrue);
      expect(repository.lastPageLimit, 6);

      provider.loadMore();
      await Future<void>.delayed(Duration.zero);

      expect(repository.lastPageLimit, 12);
      expect(provider.hasMore, isFalse);

      provider.dispose();
    });
  });
}
