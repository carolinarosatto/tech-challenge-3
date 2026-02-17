import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';

class TransactionsFilterEntity {
  const TransactionsFilterEntity({
    this.types = const <TransactionType>{},
    this.categories = const <TransactionCategory>{},
    this.direction,
  });

  final Set<TransactionType> types;
  final Set<TransactionCategory> categories;
  final TransactionDirection? direction;

  static const TransactionsFilterEntity empty = TransactionsFilterEntity();

  bool get hasFilters =>
      types.isNotEmpty || categories.isNotEmpty || direction != null;

  TransactionsFilterEntity copyWith({
    Set<TransactionType>? types,
    Set<TransactionCategory>? categories,
    TransactionDirection? direction,
    bool removeDirection = false,
  }) {
    return TransactionsFilterEntity(
      types: types ?? this.types,
      categories: categories ?? this.categories,
      direction: removeDirection ? null : direction ?? this.direction,
    );
  }
}
