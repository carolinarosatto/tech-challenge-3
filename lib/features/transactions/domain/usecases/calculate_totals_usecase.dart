import 'package:tech_challenge_3/features/transactions/domain/entities/transaction_entity.dart';

class TransactionsTotals {
  const TransactionsTotals({
    required this.byCategory,
    required this.totalIncome,
    required this.totalOutcome,
  });

  final Map<TransactionCategory, double> byCategory;
  final double totalIncome;
  final double totalOutcome;

  double get balance => totalIncome - totalOutcome;
}

class CalculateTotalsUseCase {
  const CalculateTotalsUseCase();

  TransactionsTotals execute(List<TransactionEntity> transactions) {
    final totalsByCategory = <TransactionCategory, double>{};
    var totalIncome = 0.0;
    var totalOutcome = 0.0;

    for (final transaction in transactions) {
      final absoluteAmount = transaction.amount.abs();

      if (transaction.type.direction == TransactionDirection.income) {
        totalIncome += absoluteAmount;
        continue;
      }

      totalOutcome += absoluteAmount;
      totalsByCategory.update(
        transaction.category,
        (current) => current + absoluteAmount,
        ifAbsent: () => absoluteAmount,
      );
    }

    return TransactionsTotals(
      byCategory: Map.unmodifiable(totalsByCategory),
      totalIncome: totalIncome,
      totalOutcome: totalOutcome,
    );
  }
}
