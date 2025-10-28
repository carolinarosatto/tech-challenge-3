enum TransactionDirection {
  income, // entrada de dinheiro
  expense, // saída de dinheiro
}

extension TransactionDirectionExtension on TransactionDirection {
  String get label {
    switch (this) {
      case TransactionDirection.income:
        return 'Entrada';
      case TransactionDirection.expense:
        return 'Saída';
    }
  }

  static TransactionDirection fromString(String value) {
    switch (value) {
      case 'income':
        return TransactionDirection.income;
      case 'expense':
        return TransactionDirection.expense;
      default:
        throw ArgumentError('Natureza inválida: $value');
    }
  }
}
