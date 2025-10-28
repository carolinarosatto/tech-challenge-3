import 'package:tech_challenge_3/models/enums/transaction_direction.dart';

enum TransactionType {
  deposito,
  saque,
  investimento,
  rendimento,
  pagamento,
  transferencia,
}

extension TransactionTypeExtension on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.deposito:
        return 'Depósito';
      case TransactionType.saque:
        return 'Saque';
      case TransactionType.investimento:
        return 'Investimento';
      case TransactionType.rendimento:
        return 'Rendimento';
      case TransactionType.pagamento:
        return 'Pagamento';
      case TransactionType.transferencia:
        return 'Transferência';
    }
  }

  /// Define se é entrada ou saída de dinheiro
  TransactionDirection get nature {
    switch (this) {
      case TransactionType.deposito:
      case TransactionType.rendimento:
        return TransactionDirection.income;

      case TransactionType.saque:
      case TransactionType.investimento:
      case TransactionType.pagamento:
      case TransactionType.transferencia:
        return TransactionDirection.expense;
    }
  }

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransactionType.saque,
    );
  }
}
