enum TransactionCategory {
  alimentacao,
  transporte,
  moradia,
  lazer,
  saude,
  educacao,
  pets,
  outros,
}

extension TransactionCategoryExtension on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.alimentacao:
        return 'Alimentação';
      case TransactionCategory.transporte:
        return 'Transporte';
      case TransactionCategory.moradia:
        return 'Moradia';
      case TransactionCategory.lazer:
        return 'Lazer';
      case TransactionCategory.saude:
        return 'Saúde';
      case TransactionCategory.educacao:
        return 'Educação';
      case TransactionCategory.pets:
        return 'Pets';
      case TransactionCategory.outros:
        return 'Outros';
    }
  }

  static TransactionCategory fromString(String value) {
    return TransactionCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransactionCategory.outros,
    );
  }
}
