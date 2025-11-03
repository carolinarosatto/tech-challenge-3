enum TransactionType {
  deposit,
  withdrawal,
  investment,
  income,
  payment,
  transfer,
}

enum TransactionDirection {
  income, // entrada
  expense, // saída
}

extension TransactionTypeExtension on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.deposit:
        return 'Depósito';
      case TransactionType.withdrawal:
        return 'Saque';
      case TransactionType.investment:
        return 'Investimento';
      case TransactionType.income:
        return 'Rendimento';
      case TransactionType.payment:
        return 'Pagamento';
      case TransactionType.transfer:
        return 'Transferência';
    }
  }

  TransactionDirection get direction {
    switch (this) {
      case TransactionType.deposit:
      case TransactionType.income:
        return TransactionDirection.income;
      default:
        return TransactionDirection.expense;
    }
  }

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransactionType.payment,
    );
  }
}
