import 'package:tech_challenge_3/models/enums/transaction_categories.dart';
import 'package:tech_challenge_3/models/enums/transaction_type.dart';

class TransactionsFilter {
  final Set<TransactionType> types;
  final Set<TransactionCategory> categories;
  final TransactionDirection? direction;

  const TransactionsFilter({
    this.types = const <TransactionType>{},
    this.categories = const <TransactionCategory>{},
    this.direction,
  });

  static const TransactionsFilter empty = TransactionsFilter();

  bool get hasFilters =>
      types.isNotEmpty ||
      categories.isNotEmpty ||
      direction != null;

  TransactionsFilter copyWith({
    Set<TransactionType>? types,
    Set<TransactionCategory>? categories,
    TransactionDirection? direction,
    bool removeDirection = false,
  }) {
    return TransactionsFilter(
      types: types ?? this.types,
      categories: categories ?? this.categories,
      direction: removeDirection ? null : direction ?? this.direction,
    );
  }
}
