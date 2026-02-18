import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';
import 'package:tech_challenge_3/features/transactions/domain/entities/transactions_filter_entity.dart';

class FilterTransactionsUseCase {
  const FilterTransactionsUseCase();

  List<TransactionEntity> execute({
    required List<TransactionEntity> transactions,
    required TransactionsFilterEntity filters,
  }) {
    if (!filters.hasFilters) {
      return List.unmodifiable(transactions);
    }

    return List.unmodifiable(
      transactions.where((transaction) => _matches(transaction, filters)),
    );
  }

  bool _matches(
    TransactionEntity transaction,
    TransactionsFilterEntity filters,
  ) {
    if (filters.direction != null &&
        transaction.type.direction != filters.direction) {
      return false;
    }

    if (filters.types.isNotEmpty && !filters.types.contains(transaction.type)) {
      return false;
    }

    if (filters.categories.isNotEmpty &&
        !filters.categories.contains(transaction.category)) {
      return false;
    }

    return true;
  }
}
